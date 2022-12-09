#' ---
#' title: "Multinomial logistic regression"
#' author: "Michael Friendly"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: readable
#'     code_download: true
#' ---

#' ## Fit models for women's labor force participation

library(car)
library(nnet)   # for `multinom()`
library(dplyr)
data(Womenlf, package = "carData")

#' #### make `not.work` the reference category

Womenlf <- within (Womenlf, {
  partic <- ordered(partic, levels=c('not.work', 'parttime', 'fulltime'))})

#' ## Fit model with main effects
wlf.multinom <- multinom(partic ~ hincome + children, 
                         data=Womenlf, Hess=TRUE)
#' ## Summaries
summary(wlf.multinom, Wald=TRUE)

#' `broom::tidy()` puts this in a more convenient format
broom::tidy(wlf.multinom)

#' ## Anova tests
Anova(wlf.multinom)

# overall test?
car::linearHypothesis(wlf.multinom, "hincome, childrenpresent")

#' ## Examine coefficients
coef(wlf.multinom)
exp(coef(wlf.multinom))


#' ## Wald tests & p-values
stats <- summary(wlf.multinom, Wald=TRUE)
z <- stats$Wald.ratios
p <- 2 * (1 - pnorm(abs(z)))
zapsmall(p)


#' ## Plot fitted values in two panels
op <- par(mfrow=c(1,2))

predictors <- expand.grid(hincome=1:45, children=c('absent', 'present'))
p.fit <- predict(wlf.multinom, predictors, type='probs')
Hinc <- 1:max(predictors$hincome)
for ( kids in c("absent", "present") ) {
	data <- subset(data.frame(predictors, p.fit), children==kids)
	plot( range(Hinc), c(0,1), type="n",
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



#' ## Effect plots
#' 
wlf.effects <- allEffects(wlf.multinom)
plot(wlf.effects, style='stacked')

plot(Effect(c("hincome", "children"), wlf.multinom), 
     style = "stacked", key.args=list(x=.75, y=.25),
     colors = c(grey(.85), "pink", "lightblue")
     )


#' ## plotting probabilities

#' get fitted probabilities
options(digits=3)
predictors <- expand.grid(hincome=1:50, children=c('absent', 'present'))
fit <- data.frame(predictors, 
                  predict(wlf.multinom, predictors, type='probs'))


#' ## Re-shape for plotting
library(tidyr)

#' tidyr::gather()
plotdat <- fit |>
  gather(key="Level", value="Probability", not.work:fulltime) 


plotdat <- fit |>
  pivot_longer(not.work:fulltime, 
               names_to = "Level",
               values_to = "Probability") 
head(plotdat)

library(directlabels)
gg <-
ggplot(plotdat, aes(x = hincome, y = Probability, colour = Level)) + 
  geom_line(size=1.5) + theme_bw() + 
  facet_grid(~ children, labeller = label_both) +
  theme_bw(base_size = 14)
direct.label(gg, list("top.bumptwice", dl.trans(y = y + 0.2)))


