library(DBI)
library(RSQLite)
library(ggplot2)
library(plyr)
library(reshape2)

db <- dbConnect(drv = SQLite(), dbname = "~/Github/rlanguage/thinkstats/db/thinstats.db")
FemalePreg2002 <- dbReadTable(db, "FemalePreg2002")

FirstChild.birthwgt_oz <- subset(FemalePreg2002, birthord==1, "birthwgt_oz")
FirstChild.birthwgt_lb <- subset(FemalePreg2002, birthord==1, "birthwgt_lb")

OtherChild.birthwgt_oz <- subset(FemalePreg2002, birthord!=1, "birthwgt_oz")
OtherChild.birthwgt_lb <- subset(FemalePreg2002, birthord!=1, "birthwgt_lb")


FirstChild <- data.frame(
  group="First Child",
  if (!is.na(FirstChild.birthwgt_lb) && 
      FirstChild.birthwgt_lb<20 && 
      !is.na(FirstChild.birthwgt_oz) &&
      FirstChild.birthwgt_oz <=16) 
    FirstChild.birthwgt_lb*16+FirstChild.birthwgt_oz
  else
    NA
  )
names(FirstChild) = c("group", "totalWeight")

OtherChild <- data.frame(
  group="Others",
  if(!is.na(OtherChild.birthwgt_lb) &&
       OtherChild.birthwgt_lb<20 &&
       !is.na(OtherChild.birthwgt_oz) &&
       OtherChild.birthwgt_oz <=16)
    OtherChild.birthwgt_lb*16+OtherChild.birthwgt_oz
  else
    NA
  )
names(OtherChild) = c("group", "totalWeight")

#calculate CDF
FirstChild.cdf <- ddply(.data = FirstChild, 
                        .variables = "group", 
                        .fun = summarise, 
                        totalWeight=totalWeight, 
                        cdf=ecdf(totalWeight)(totalWeight)
    )

OtherChild.cdf <- ddply(.data = OtherChild, 
                        .variables = "group", 
                        .fun = summarise, 
                        totalWeight=totalWeight, 
                        cdf=ecdf(totalWeight)(totalWeight)
)

# rbind
Child.CDF <- rbind(FirstChild.cdf, OtherChild.cdf)

#draw CDF charts
ggplot(Child.CDF, aes(x=totalWeight,y=cdf, colour=group)) + 
  geom_step(size=1) + 
  xlim(0, 250)+
  xlab("Weight in Ounce") +
  ylab("Probability") +
  ggtitle("Birth Weight CDF")