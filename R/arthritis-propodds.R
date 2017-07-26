#' ---
#' title: "Arthritis data: Proportional odds model"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---
library(vcd)
library(car)         # for Anova()
library(MASS)        # for polr()

arth.polr <- polr(Improved ~ Sex + Treatment + Age, data=Arthritis)
summary(arth.polr)
Anova(arth.polr)      # Type II tests

library(effects)
arth.effects <- allEffects(arth.polr, xlevels=list(age=seq(15,45,5)) )
plot(arth.effects)  # visualize all main effects

#' ## plot terms not in model
plot(effect("Sex:Age", arth.polr))
plot(effect("Treatment:Age", arth.polr))


