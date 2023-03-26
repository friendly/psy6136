#' ---
#' title: "Arthritis data: Proportional odds model"
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
#' 
library(vcd)
library(car)         # for Anova()
library(MASS)        # for polr()
library(effects)     # effect plots

data(Arthritis, package = "vcd")

#' ## Fit the proportional odds model
#' 
arth.polr <- polr(Improved ~ Sex + Treatment + Age, data=Arthritis)
summary(arth.polr)
Anova(arth.polr)      # Type II tests

arth.effects <- allEffects(arth.polr, xlevels=list(age=seq(15,45,5)) )
plot(arth.effects)  # visualize all main effects

#' ## plot terms not in model
plot(effect("Sex:Age", arth.polr))
plot(effect("Treatment:Age", arth.polr))


