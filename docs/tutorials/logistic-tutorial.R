#' ---
#' title: "Cowles data: Logistic regression tutorial"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---

library(effects)   ## load the effects package
library(car)       ## for Anova: type II tests
data(Cowles)

#' ## Start with some basic summaries and plots (not too useful)
summary(Cowles)
plot(Cowles)
car::scatterplotMatrix(Cowles)

#' ## Main effects model
mod.cowles0 <- glm(volunteer ~ sex + neuroticism + extraversion, 
    data=Cowles, family=binomial)
summary(mod.cowles0)
Anova(mod.cowles0)


#' ## Test all interactions
mod.cowles1 <- glm(volunteer ~ (sex + neuroticism + extraversion)^2, 
    data=Cowles, family=binomial)
summary(mod.cowles1)
Anova(mod.cowles1)

#' ## Add one interaction
mod.cowles <- glm(volunteer ~ sex + neuroticism * extraversion, 
    data=Cowles, family=binomial)
summary(mod.cowles)

#' ## Compare models
anova(mod.cowles0, mod.cowles, mod.cowles1, test="Chisq")
LRstats(mod.cowles0, mod.cowles, mod.cowles1)

#' Effect plots
eff.cowles <- allEffects(mod.cowles, 
			xlevels=list(extraversion=seq(0, 24, 8)))
plot(eff.cowles, multiline=TRUE)

plot(eff.cowles, 'neuroticism:extraversion', ylab="Prob(Volunteer)",
    ticks=list(at=c(.1,.25,.5,.75,.9)), layout=c(4,1), aspect=1)

plot(eff.cowles, 'neuroticism:extraversion', multiline=TRUE, 
    ylab="Prob(Volunteer)", 
    key.args=list(x = .8, y = .9))


