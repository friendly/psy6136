#' ---
#' title: "Multinomial logistic regression"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---

# multinomial logistic regression

library(car)
data(Womenlf)
attach(Womenlf)

# make ordered factor
participation <- ordered(partic, 
    levels=c('not.work', 'parttime', 'fulltime'))

#' ## Fit model
library(nnet)
mod.multinom <- multinom(participation ~ hincome + children)
summary(mod.multinom, Wald=TRUE)
Anova(mod.multinom)

#' Plot fitted values
predictors <- expand.grid(hincome=1:45, children=c('absent', 'present'))
p.fit <- predict(mod.multinom, predictors, type='probs')

Hinc <- 1:max(hincome)
plot(range(hincome), c(0,1), 
    type='n', xlab="Husband's Income", ylab='Fitted Probability',
    main="Children absent")
lines(Hinc, p.fit[Hinc, 'not.work'], lty=1, lwd=3, col="black")
lines(Hinc, p.fit[Hinc, 'parttime'], lty=2, lwd=3, col="blue")
lines(Hinc, p.fit[Hinc, 'fulltime'], lty=3, lwd=3, col="red")

legend(5, 0.97, lty=1:3, lwd=3, col=c("black", "blue", "red"),
    legend=c('not working', 'part-time', 'full-time'))  

plot(range(hincome), c(0,1), 
    type='n', xlab="Husband's Income", ylab='Fitted Probability',
    main="Children present")
lines(Hinc, p.fit[46:90, 'not.work'], lty=1, lwd=3, col="black")
lines(Hinc, p.fit[46:90, 'parttime'], lty=2, lwd=3, col="blue")
lines(Hinc, p.fit[46:90, 'fulltime'], lty=3, lwd=3, col="red")


# a more general way to make the plot
op <- par(mfrow=c(1,2))
Hinc <- 1:max(hincome)
for ( kids in c("absent", "present") ) {
	data <- subset(data.frame(predictors, p.fit), children==kids)
	plot( range(hincome), c(0,1), type="n",
		xlab="Husband's Income", ylab='Fitted Probability',
		main = paste("Children", kids))
	lines(Hinc, data[, 'not.work'], lwd=3, col="black", lty=1)
	lines(Hinc, data[, 'parttime'], lwd=3, col="blue",  lty=2)
	lines(Hinc, data[, 'fulltime'], lwd=3, col="red",   lty=3)
  if (kids=="absent") {
  legend(5, 0.97, lty=1:3, lwd=3, col=c("black", "blue", "red"),
    legend=c('not working', 'part-time', 'full-time'))
    }
}
par(op)


detach(Womenlf)
