library(DBI)
library(RSQLite)
library(ggplot2)
library(plyr)

db <- dbConnect(drv = SQLite(), dbname = "~/Github/rlanguage/thinkstats/db/thinstats.db")
FemalePreg2002 <- dbReadTable(db, "FemalePreg2002")

FirstChild <- subset(FemalePreg2002, birthord==1, c("caseid","prglength"))
FirstChild <- cbind(group="First Child", FirstChild)
OtherChild <- subset(FemalePreg2002, birthord>1, c("caseid","prglength"))
OtherChild <- cbind(group="Others", OtherChild)

FirstChild <- melt(FirstChild, id=c("group", "prglength"), na.rm = T)
OtherChild <- melt(OtherChild, id=c("group","prglength"), na.rm = T)

data <- rbind(FirstChild, OtherChild)

Factor <- as.factor(data$group)

ggplot(data = data) +
  geom_bar(aes(x = prglength, fill=Factor), position = "dodge") +
  xlab("Pregnant Length") +
  ylab("Frequency")