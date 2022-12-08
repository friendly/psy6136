#' ---
#' title: "Arthritis data: Logistic regression"
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

library(vcd)
library(car)
data(Arthritis, package = "vcd")

#' ## define Better from ordinal Improved
Arthritis$Better <- Arthritis$Improved > 'None'

#' ## simple linear logistic regression
arth.mod0 <- glm(Better ~ Age, data=Arthritis, family='binomial')
anova(arth.mod0)

#' ## plot, with +-1 SE
plot(Better ~ Age, data=Arthritis, ylab="Prob (Better)")
pred <- predict(arth.mod0, type="response", se.fit=TRUE)
ord <-order(Arthritis$Age)

lines(Arthritis$Age[ord], pred$fit[ord], lwd=3)
upper <- pred$fit + pred$se.fit
lower <- pred$fit - pred$se.fit
lines(Arthritis$Age[ord], upper[ord], lty=2, col="blue")
lines(Arthritis$Age[ord], lower[ord], lty=2, col="blue")
# smoothed non-parametric curve
lines(lowess(Arthritis$Age[ord], Arthritis$Better[ord]), lwd=2, col="red")

#' ## main effects model
arth.mod1 <- glm(Better ~ Age + Sex + Treatment , data=Arthritis, family='binomial')
Anova(arth.mod1)

#' same, using update()
arth.mod1 <- update(arth.mod0, . ~ . + Sex + Treatment)
Anova(arth.mod1)

#' ## plots, using effects package
library(effects)
arth.eff <- allEffects(arth.mod1, xlevels=list(Age=seq(25,75,5)))
plot(arth.eff, ylab="Prob(Better)")

#' ## forward selection from the main effects model
step(arth.mod1, direction="forward", scope=.~ (Age+Sex+Treatment)^2 + Age^2)
