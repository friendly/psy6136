#' ---
#' title: "Arrests data: Logistic regression"
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

#' ## Load packages
library(effects)    # for effect plots
library(car)        # for Anova()
library(MASS)       # for stepAIC

#' ## Load the data
data(Arrests, package = "carData")
Arrests$year <- as.factor(Arrests$year)

#' ## all main effects
arrests.mod1 <- glm(released ~ ., family=binomial, data=Arrests)
Anova(arrests.mod1)

#' ## all two-way effects
arrests.mod2 <- glm(released ~ .^2, family=binomial, data=Arrests)
Anova(arrests.mod2)

#' ## Model selection using add1, drop1 & stepAIC


#' Add single two-way interactions, starting from the main effects model
add1(arrests.mod1, scope= ~.^2, test="Chisq")

#' Drop single two-way interactions, starting from the all two-way model
drop1(arrests.mod2, test="Chisq")


#' ## Stepwise backward selection, using `MASS::stepAIC()`
arrests.step <- stepAIC(arrests.mod2, direction="backward")

#' ## Compare models
anova(arrests.mod1, arrests.step, arrests.mod2, test="Chisq")

#' ## one reduced model, using interactions of colour with year and age
arrests.mod <- glm(released ~ employed + citizen + checks + colour*year + colour*age,
 family=binomial, data=Arrests)

#' ## Type II tests of terms in our model
Anova(arrests.mod)




