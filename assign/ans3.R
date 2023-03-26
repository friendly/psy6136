#' ---
#' title: "Assignment 2: Some solutions"
#' author: "Michael Friendly"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: readable
#'     code_download: true
#' ---

#+ echo=FALSE
knitr::opts_chunk$set(
  warning = FALSE,   # avoid warnings and messages in the output
  message = FALSE
)

#' ## Exercise 4.2: Abortion data

library(vcdExtra)
data(Abortion, package="vcdExtra")
structable(Abortion)

#' ### 4.2a, b: Fourfold displays, stratified by status and sex
#' Permuting the table dimensions gives different views
Abortion2<-aperm(Abortion, c(1,3,2))
fourfold(Abortion2)

Abortion3<-aperm(Abortion, c(2,3,1))
fourfold(Abortion3)

#' ### 4.2c: odds ratios
#' Sex by support for abortion, stratified by status
summary(oddsratio(Abortion2))

#' Status by support for abortion, stratified by sex
summary(oddsratio(Abortion3)) 

#' ### Summary
#' Support for abortion differs by sex and status. Among low status individuals,
#' there is a strong tendency for women to support it compared to men. There
#' is no association between sex and support among men.
#' 
#' 
#' ## Exercise 4.4: Hospital visits
#' $\chi^2$ test and association
str(Hospital)
chisq.test(Hospital)
assocstats(Hospital)

#' There is a strong association between visit frequency and length of stay
#'
#' ### Association plot
#' The association plot shows that regular visits lead to shorter length of stay,
#' never visiting to longer length of stay
assoc(Hospital, shade=TRUE)

#' ### CHMtest for ordinal variables
#' All CMH tests are significant, but the test for non-zero correlation has the largest
#' $\chi^2 /df$ and the smallest p-value.
CMHtest(Hospital)

#' ### other plots
plot(Hospital, shade=TRUE)
tile(Hospital, shade=TRUE)
mosaic(Hospital, shade=TRUE)
spineplot(Hospital)

#' ## Exercise 4.6: Mammograms
str(Mammograms)
Mammograms

#' ### Kappa
#' The unweighted $\kappa = 0.37$ is moderately strong, but the weighted versions,
#' particularly using Fleiss-Cohen weights show very strong agreement, allowing
#' for small steps of disagreement.
Kappa(Mammograms)
Kappa(Mammograms, weights= "Fleiss-Cohen")
confint(Kappa(Mammograms))

#' ### Agreement plots
#' The agreement plots illustrate the strength of agreement. There is no tendency for the
#' boxes to deviate systematically from the diagonal line, indicating that the two readers
#' use the diagnostic categories more or less the same, except for the `Severe` category.
#' 
agreementplot(Mammograms, main="Unweighted", weights=1)
agreementplot(Mammograms, main="Weighted")






