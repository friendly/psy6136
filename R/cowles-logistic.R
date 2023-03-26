#' ---
#' title: "Cowles data: Logistic regression"
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

#' ## Load packages and data
library(effects)   ## load the effects package
library(car)       ## for Anova: type II tests
data(Cowles, package = "carData")

#' ## Main effects model
mod.cowles0 <- glm(volunteer ~ sex + neuroticism + extraversion, 
    data=Cowles, family=binomial)
summary(mod.cowles0)
Anova(mod.cowles0)


#' ## Test all interactions
mod.cowles1 <- glm(volunteer ~ (sex + neuroticism + extraversion)^2, 
    data=Cowles, family=binomial)
summary(mod.cowles1)
Anova(mod.cowles1)

#' ## Add one interaction
mod.cowles <- glm(volunteer ~ sex + neuroticism * extraversion, 
    data=Cowles, family=binomial)
summary(mod.cowles)

anova(mod.cowles0, mod.cowles, mod.cowles1)




