#' ---
#' title: "Some R solutions for Assign 1"
#' author: "Michael Friendly"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: readable
#'     code_download: true
#' ---


#' ## Exercise 2.2

#' ### (a) Abortion opinion data
data(Abortion, package="vcdExtra")
str(Abortion)

#' `Support_Abortion` is the response, `Sex` and `Status` are binary, nominal explanatory variables. 
#' Q: How does support for abortion depend on sex and status?

#' ## (b) Caesarian Births: Caesar
data(Caesar, package = "vcdExtra")

#' `Infection` is a 3-level response variable; the explanatory variables are
#' `Risk` (a two-level nominal variable), whether `Antibiotics` were used (a two-level nominal variable), and whether the Caesarian section was `Planned` or not (a two-level nominal variable). 
#' Q: How antibiotics, risk, and whether the operation was planned are associated with infection type (or no infection)?

#' Similarly for the other two datasets

#' ## Exercise 2.4: Danish Welfare

library(vcdExtra)
data(DanishWelfare, package="vcdExtra")
str(DanishWelfare)
sum(DanishWelfare$Freq)  # total cases

#' ### Ordering Alcohol and Income
levels(DanishWelfare$Alcohol)
DanishWelfare$Alcohol <- ordered(DanishWelfare$Alcohol, levels=c("<1", "1-2", ">2"))

levels(DanishWelfare$Income)
DanishWelfare$Income <- ordered(DanishWelfare$Income, levels=c("0-50","50-100","100-150",">150"))

#' or, simpler, using as.ordered():
DanishWelfare$Alcohol <- as.ordered(DanishWelfare$Alcohol)
DanishWelfare$Income <- as.ordered(DanishWelfare$Income)

#' now they are **ordered factors**
str(DanishWelfare)

#' ### convert to table form
Danish.tab <- xtabs(DanishWelfare)
# same, using formula method
Danish.tab <- xtabs(Freq ~ ., data=DanishWelfare)

str(Danish.tab)
structable(Danish.tab)

#' ### Urban factor
margin.table(Danish.tab, 4)

#' Collapse categories
Danish.tab2 <- collapse.table(Danish.tab, Urban=c("City","City","City","City","NonCity"))

structable(Danish.tab2)

structable(Alcohol ~ Urban+Status+Income,  Danish.tab2)



#'  ## Exercise 2.5

data(UKSoccer, package="vcd")
# total games
sum(UKSoccer)

# marginal totals
addmargins(UKSoccer)
# or
rowSums(UKSoccer)
colSums(UKSoccer)
# or
home <- margin.table(UKSoccer, 1)
away <- margin.table(UKSoccer, 2)

# proportions
prop.table(margin.table(UKSoccer,1))
prop.table(margin.table(UKSoccer,2))


# compare distribution of home & away goals
library(vcd)
goodfit(home, type="poisson")
goodfit(away, type="poisson")
plot(goodfit(home, type="poisson"))
plot(goodfit(away, type="poisson"))

# make a 5 x 2 table
tab <- rbind(home,away)
names(dimnames(tab)) <- c("Team", "Goals")
chisq.test(tab)
mosaic(tab, shade=TRUE)


# mean goals scores-- need to use weighted.mean ...
weighted.mean(0:4, w=home)
weighted.mean(0:4, w=away)
# ... or else expand frequencies to a data frame of 380 games
Home <- rep(0:4, times=home)
Away <- rep(0:4, times=away)
HA <- data.frame(Home, Away)
summary(HA)

boxplot(HA, ylab="Goals scored")

