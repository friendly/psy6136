#' ---
#' title: "Working with R data"
#' author: "Michael Friendly"
#' date: "15/01/15 15:03:10"
#' ---

#' ## Data in R packages
data()               # the datasets package
data(package="vcd")  # in the vcd package

#' typically, load data from a package using data()
data(UCBAdmissions)
str(UCBAdmissions)
sum(UCBAdmissions)
margin.table(UCBAdmissions, 1)
margin.table(UCBAdmissions, 2:3)

#' ## data frames
library(vcd)         # load the vcd package & make its datasets available
data(Arthritis)
str(Arthritis)

head(Arthritis)      # see the first few lines

#' making tables from data frame variables
table(Arthritis$Improved)
table(Arthritis$Treatment, Arthritis$Sex)
with(Arthritis, table(Treatment, Sex))

#' xtabs() is often easier
art.table <- xtabs(~ Sex + Treatment + Improved, data=Arthritis)
ftable(art.table)    # display as flattened table
summary(art.table)   # chi-square test for mutual independence
plot(art.table, shade=TRUE) 

#' ## Reading data from external files
#' 
#' read a data table from a local file (NB: '/' not '\' for all systems)
# arthritis <- read.csv("N:/psy6136/data/arthritis.csv")
# arthritis <- read.csv(file.choose())  
# or, read the same data from a web URL ...
arthritis <- read.csv("http://euclid.psych.yorku.ca/www/psy6136/data/Arthritis.csv")

levels(arthritis$Improved)

#' make an ordered factor
arthritis$Improved <- ordered(arthritis$Improved,
                              levels=c("None", "Some", "Marked"))

#' make a variable discrete: cut and arithmetic
table(10*floor(arthritis$Age/10)) 
table(cut(arthritis$Age, breaks=6))

#' assign new variable in data frame
arthritis$AgeGroup <- factor(10*floor(arthritis$Age/10))

#' simple plots
plot(arthritis$Age)      # index plot
plot(arthritis$AgeGroup) # barplot for a factor

plot(Improved ~ AgeGroup, data=arthritis) # spineplot for two factors
plot(arthritis[,2:5])    # scatterplot matrix; not too useful for factors


