#' ---
#' title: "Arthritis data: diagnostic plots"
#' author: "Michael Friendly"
#' date: "22 Jan 2015"
#' ---


library(vcd)
#' ## main effects model
data(Arthritis)
# define Better
Arthritis$Better <- Arthritis$Improved > 'None'
arth.mod1 <- glm(Better ~ Age + Sex + Treatment , data=Arthritis, family='binomial')
Anova(arth.mod1)

#' ## diagnostic plots: "regression quartet"
op <- par(mfrow=c(2,2))
plot(arth.mod1)
par(op)

library(car)
#' ## influence plot
influencePlot(arth.mod1, main="Arthritis data: influencePlot")
