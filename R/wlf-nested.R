#' ---
#' title: "Polytomous Data: nested dichotomies"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---


library(car)   # for data and Anova()
data(Womenlf)
some(Womenlf)

#' ## create dichotomies
Womenlf <- within(Womenlf,{
  working <- recode(partic, " 'not.work' = 'no'; else = 'yes' ")
  fulltime <- recode (partic, 
    " 'fulltime' = 'yes'; 'parttime' = 'no'; 'not.work' = NA")})
some(Womenlf)

#' ## fit models for each dichotomy
Womenlf <- within(Womenlf, contrasts(children)<- 'contr.treatment')
mod.working <- glm(working ~ hincome + children, family=binomial, data=Womenlf)
summary(mod.working)
mod.fulltime <- glm(fulltime ~ hincome + children, family=binomial, data=Womenlf)
summary(mod.fulltime)
Anova(mod.working)  
Anova(mod.fulltime)

#' Prepare for plotting

attach(Womenlf)
# get fitted values for both sub-models
predictors <- expand.grid(hincome=1:45, children=c('absent', 'present'))
p.work <- predict(mod.working, predictors, type='response')
p.fulltime <- predict(mod.fulltime, predictors, type='response')

# calculate unconditional probs for the three response categories
p.full <- p.work * p.fulltime
p.part <- p.work * (1 - p.fulltime)
p.not <- 1 - p.work

## NB: the plot looks best if the plot window is made wider than tall
op <- par(mfrow=c(1,2))
# children absent panel
plot(c(1,45), c(0,1), 
    type='n', xlab="Husband's Income", ylab='Fitted Probability',
    main="Children absent")
lines(1:45, p.not[1:45], lty=1, lwd=3, col="black")
lines(1:45, p.part[1:45], lty=2, lwd=3, col="blue")
lines(1:45, p.full[1:45], lty=3, lwd=3, col="red")

legend(5, 0.97, lty=1:3, lwd=3, col=c("black", "blue", "red"),
    legend=c('not working', 'part-time', 'full-time'))  

# children present panel
plot(c(1,45), c(0,1), 
    type='n', xlab="Husband's Income", ylab='Fitted Probability',
    main="Children present")
lines(1:45, p.not[46:90], lty=1, lwd=3, col="black")
lines(1:45, p.part[46:90], lty=2, lwd=3, col="blue")
lines(1:45, p.full[46:90], lty=3, lwd=3, col="red")
par(op)

#' ## a more general way to make the plot
op <- par(mfrow=c(1,2))
plotdata <- data.frame(predictors, p.full, p.part, p.not)
Hinc <- 1:max(hincome)
for ( kids in c("absent", "present") ) {
	data <- subset(plotdata, children==kids)
	plot( range(hincome), c(0,1), type="n",
		xlab="Husband's Income", ylab='Fitted Probability',
		main = paste("Children", kids))
	lines(Hinc, data$p.not,  lwd=3, col="black", lty=1)
	lines(Hinc, data$p.part, lwd=3, col="blue",  lty=2)
	lines(Hinc, data$p.full, lwd=3, col="red",   lty=3)
  if (kids=="absent") {
  legend(5, 0.97, lty=1:3, lwd=3, col=c("black", "blue", "red"),
    legend=c('not working', 'part-time', 'full-time'))
    }
}
par(op)


detach(Womenlf)
  
