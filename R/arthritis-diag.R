#' ---
#' title: "Arthritis data: diagnostic plots"
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
data(Arthritis)

#' ## define Better
Arthritis$Better <- Arthritis$Improved > 'None'

#' ## main effects model for the binary response
arth.mod1 <- glm(Better ~ Age + Sex + Treatment , data=Arthritis, family='binomial')
Anova(arth.mod1)

#' ## diagnostic plots: "regression quartet"
op <- par(mfrow=c(2,2))
plot(arth.mod1)
par(op)

#' ## influence plot
influencePlot(arth.mod1, main="Arthritis data: influencePlot")
