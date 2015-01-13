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

# prepare data for barchart
FirstChild <- melt(FirstChild, id=c("group", "prglength"), na.rm = T)
OtherChild <- melt(OtherChild, id=c("group","prglength"), na.rm = T)

# bind row data
data <- rbind(FirstChild, OtherChild)

# set to factor for filling different group in barchart
Factor <- as.factor(data$group)

## ggplot2
ggplot(data = data) +
  geom_bar(aes(x = prglength, fill=Factor), position = "dodge", binwidth = 1) +
  ggtitle("Frequency of Pregnant Length") +
  xlab("Pregnant Length") +
  ylab("Frequency")
