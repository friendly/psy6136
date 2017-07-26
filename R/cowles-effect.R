#' ---
#' title: "Cowles data: Effect plots"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---

library(effects)   ## load the effects package
data(Cowles)

#' ## Model with interaction
mod.cowles <- glm(volunteer ~ sex + neuroticism*extraversion, 
    data=Cowles, family=binomial)
summary(mod.cowles)

eff.cowles <- allEffects(mod.cowles, 
	xlevels=list(neuroticism=seq(0, 24, 6), 
               extraversion=seq(0, 24, 8)))

plot(eff.cowles, 'neuroticism:extraversion', ylab="Prob(Volunteer)",
    ticks=list(at=c(.1,.25,.5,.75,.9)), layout=c(4,1), aspect=1)

plot(eff.cowles, 'neuroticism:extraversion', multiline=TRUE, 
    ylab="Prob(Volunteer)", 
    key.args=list(x = .8, y = .9))

