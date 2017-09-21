#' ---
#' title: "Assignment 3: Some solutions"
#' author: "Michael Friendly"
#' date: "4 Feb 2015"
#' ---

#' ## Exercise 4.2: Abortion data

library(vcdExtra)
data(Abortion, package="vcdExtra")
structable(Abortion)

#' ###4.2a, b: Fourfold displays, stratified by status and sex
Abortion2<-aperm(Abortion, c(1,3,2))
fourfold(Abortion2)

Abortion3<-aperm(Abortion, c(2,3,1))
fourfold(Abortion3)

#' ###4.2c: odds ratios
#' Sex by support for abortion, stratified by status
summary(oddsratio(Abortion2))

#' Status by support for abortion, stratified by sex
summary(oddsratio(Abortion3)) 

#' ## Exercise 4.4: Hospital visits
str(Hospital)
chisq.test(Hospital)
assocstats(Hospital)

#' Association plot
assoc(Hospital, shade=TRUE)

#' CHMtest for ordinal variables
CMHtest(Hospital)

#' other plots
plot(Hospital, shade=TRUE)
tile(Hospital, shade=TRUE)
mosaic(Hospital, shade=TRUE)
spineplot(Hospital)

#' ## Exercise 4.5: Mammograms
str(Mammograms)

Kappa(Mammograms)
Kappa(Mammograms, weights= "Fleiss-Cohen")
confint(Kappa(Mammograms))

agreementplot(Mammograms, main="Unweighted", weights=1)
agreementplot(Mammograms, main="Weighted")






