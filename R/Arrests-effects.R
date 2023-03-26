#' ---
#' title: "Arrests data: Effects plots"
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


# Examples from John Fox's JSS paper

library(effects)    # effect plots
library(car)        # for Anova()

#' ##Load the data
#' `year` is numeric, but we want to treat it as a factor
data(Arrests, package = "carData")
Arrests$year <- as.factor(Arrests$year)

#' ## Main effects model, with two interactions
arrests.mod <- glm(released ~ employed + citizen + checks +
                   colour*year + colour*age,
                   family=binomial, data=Arrests)

Anova(arrests.mod)

#' ### plot all effects
#+ fig.width=9, fig.height=4
arrests.effects <- allEffects(arrests.mod, 
                              xlevels=list(age=seq(15,45,5)))
plot(arrests.effects, 
     ylab="Probability(released)")

#' ### Plot 3-way effect (not in model)
plot(effect("colour:year:age", arrests.mod, 
            xlevels=list(age=15:45)),
     multiline=TRUE, 
     ylab="Probability(released)", 
     rug=FALSE)

#' ### colour x year interaction
plot(effect("colour:year", arrests.mod),
      multiline=TRUE, ylab="Probability(released)")

#' ### colour x age interaction
plot(effect("colour:age", arrests.mod),
      multiline=FALSE, ylab="Probability(released)")

     