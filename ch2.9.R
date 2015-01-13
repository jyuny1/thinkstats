library(DBI)
library(RSQLite)
library(ggplot2)
library(plyr)
library(reshape2)

db <- dbConnect(drv = SQLite(), dbname = "~/Github/rlanguage/thinkstats/db/thinstats.db")
FemalePreg2002 <- dbReadTable(db, "FemalePreg2002")

FirstChild <- subset(FemalePreg2002, birthord==1, c("caseid","prglength"))
FirstChild <- cbind(group="First Child", FirstChild)
OtherChild <- subset(FemalePreg2002, birthord>1, c("caseid","prglength"))
OtherChild <- cbind(group="Others", OtherChild)

FirstChildPMF <- 
# aggregate data
FirstChildPMF <- ddply(.data = FirstChild, 
      .variables = c("group", "prglength"), 
      .fun = summarise, 
      pmf=length(prglength)/length(FirstChild$prglength)*100)

OtherChildPMF <- ddply(.data = OtherChild, 
                       .variables = c("group", "prglength"), 
                       .fun = summarise, 
                       pmf=length(prglength)/length(OtherChild$prglength)*100)