#' ---
#' title: "Working with R data"
#' author: "Michael Friendly"
#' date: "`r format(Sys.Date())`"
#' ---

#' ## Data in R packages
data()               # list data in the `datasets` package
data(package="vcd")  # in the vcd package

#' `vcdExtra::datasets()` gives more detailed info on datasets in a package.
#' `knitr::kable()` turns this into a nicely formatted table.
vcdExtra::datasets("vcd") |> knitr::kable()


#' Typically, load data from a package using data()
data(UCBAdmissions)
str(UCBAdmissions)
sum(UCBAdmissions)

margin.table(UCBAdmissions, 1)
margin.table(UCBAdmissions, 2:3)

#' ## Data frames
#' 
#' #### Create a data frame from vectors
#' 
GSS <- data.frame(
  sex =   rep(c("female", "male"), times = 3), 
  party = rep(c("dem", "indep", "rep"), each = 2),
  count = c(279,165,73,47,225,191))
GSS

#' #### Load a dataset from a package
data(Arthritis, package = "vcd")
str(Arthritis)

head(Arthritis)      # see the first few lines

#' #### Making tables from data frame variables
table(Arthritis$Improved)
table(Arthritis$Treatment, Arthritis$Sex)
#' a shorthand to avoid repeating the name of the dataset
with(Arthritis, table(Treatment, Sex))

#' xtabs() is often easier
art.table <- xtabs(~ Sex + Treatment + Improved, data=Arthritis)
ftable(art.table)    # display as flattened table
summary(art.table)   # chi-square test for mutual independence

#' ## Plotting a table: mosaic plot
plot(art.table, shade=TRUE) 

#' ## Reading data from external files
#' 
#' read a data table from a local file (NB: '/' not '\' for all systems)
#' arthritis <- read.csv("N:/psy6136/data/arthritis.csv")
#' arthritis <- read.csv(file.choose())  
#' or, read the same data from a web URL ...
arthritis <- read.csv("https://raw.githubusercontent.com/friendly/psy6136/master/data/Arthritis.csv")
str(arthritis)

#' `read.csv` doesn't make categorical variables factors. They are just character variables.
levels(arthritis$Improved)    

#' ## Make an ordered factor
arthritis$Improved <- ordered(arthritis$Improved,
                              levels=c("None", "Some", "Marked"))

#' ## Make a variable discrete: `cut()` and arithmetic
table(10*floor(arthritis$Age/10)) 
table(cut(arthritis$Age, breaks=6))

#' ## assign new variable in data frame
arthritis$AgeGroup <- factor(10*floor(arthritis$Age/10))

#' ## simple plots
plot(arthritis$Age)      # index plot
plot(arthritis$AgeGroup) # barplot for a factor

plot(Improved ~ AgeGroup, data=arthritis) # spineplot for two factors
plot(arthritis[,2:5])    # scatterplot matrix; not too useful for factors


