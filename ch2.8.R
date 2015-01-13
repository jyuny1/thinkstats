library(DBI)
library(RSQLite)
library(ggplot2)
library(plyr)
library(reshape2)

db <- dbConnect(drv = SQLite(), dbname = "~/Github/rlanguage/thinkstats/db/thinstats.db")
FemalePreg2002 <- dbReadTable(db, "FemalePreg2002")

# new born baby live
newBornBabyLive <- FemalePreg2002[FemalePreg2002$nbrnaliv==1 & !is.na(FemalePreg2002$nbrnaliv), c("caseid", "prglength")]
newBornBabyLivePMF <- ddply(.data = newBornBabyLive, .variables = "prglength", .fun = summarise, count=length(caseid), pmf=length(caseid)/length(newBornBabyLive$caseid)*100)

# aggregate the data
