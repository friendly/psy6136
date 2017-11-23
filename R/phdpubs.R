#' ---
#' title: "Count data models: PhD publications"
#' author: "Michael Friendly"
#' date: "18 Nov 2017"
#' ---
# data from Long (1997)
# see http://data.princeton.edu/wws509/stata/overdispersion.html for Stata analysis

data("PhdPubs", package="vcdExtra")

library(MASS)
library(countreg)
library(vcdExtra)
library(car)
library(lmtest)    # for coeftest

#' ## a basic histogram of articles published
hist(PhdPubs$articles, breaks=0:19, col="pink", xlim=c(0,20),
     xlab="Number of Articles")

#' Fit the poisson model
phd.pois <- glm(articles ~ ., data=PhdPubs, family=poisson)
library(car)
Anova(phd.pois)

#' ## interpreting coefficients
round(cbind(beta = coef(phd.pois),
            expbeta = exp(coef(phd.pois)),
            pct = 100 * (exp(coef(phd.pois)) - 1)), 3)


#' ## check for interactions
phd.pois1 <- update(phd.pois, . ~ .^2)
Anova(phd.pois1)

anova(phd.pois, phd.pois1, test="Chisq")
LRstats(phd.pois, phd.pois1)

#'  ## model diagnostics

op <- par(mfrow=c(1,2), mar=c(4,4,2,1)+.1)
plot(phd.pois, which=c(1,5))
par(op)

#'  ### component-plus-residual plot for non-linearity
crPlot(phd.pois, "mentor", pch=16, lwd=4, id.n=2)

#' ### better version
crPlot(phd.pois, "mentor", pch=16, lwd=4, id.n=2, 
	cex.lab=1.4, xlab="mentor publications" )
text(70, 2.5, paste("b =",round( coef(phd.pois)["mentor"], 3)), col="red", cex=1.5)

#'  ### Influence plot
influencePlot(phd.pois, id.n=2)

#' Effect plots
library(effects)
plot(allEffects(phd.pois))

#' ## Overdispersion

#' mean and variance
with(PhdPubs, c(mean=mean(articles), 
                var=var(articles), 
                ratio=var(articles)/mean(articles)))

#' estimate of phi = dispersion parameter
with(phd.pois, deviance/df.residual)
sum(residuals(phd.pois, type = "pearson")^2)/phd.pois$df.residual

#' Fit the quasi-poisson model
phd.qpois <- glm(articles ~ ., data=PhdPubs, family=quasipoisson)

#' Fit the negative-binomial model
phd.nbin  <- glm.nb(articles ~ ., data=PhdPubs)

#'  ## compare models

LRstats(phd.pois, phd.qpois, phd.nbin)

#'  ## compare standard errors
phd.SE <- sqrt(cbind(
  pois = diag(vcov(phd.pois)),
  qpois = diag(vcov(phd.qpois)),
  nbin = diag(vcov(phd.nbin))))
round(phd.SE, 4)

phd.coef <- cbind(
  pois = coef(phd.pois),
  qpois = coef(phd.qpois),
  nbin = coef(phd.nbin))
round(phd.coef,3)

round(cbind(beta = coef(phd.nbin),
            expbeta = exp(coef(phd.nbin)),
            pct = 100 * (exp(coef(phd.nbin)) - 1)), 3)

#' ## zero-inflated and hurdle models

if (!require(countreg)) install.packages("countreg", repos="http://R-Forge.R-project.org")
# library(countreg)

#' ## plot zero articles

plot(factor(articles==0) ~ mentor, data=PhdPubs, 
	ylevels=2:1, ylab="Zero articles", 
	breaks=quantile(mentor, probs=seq(0,1,.2)), cex.lab=1.25)


#' Fit ZI and hurdle models
phd.zip <- zeroinfl(articles ~ ., data=PhdPubs, dist="poisson")
phd.znb <- zeroinfl(articles ~ ., data=PhdPubs, dist="negbin")

phd.hp  <- hurdle(articles ~ ., data=PhdPubs, dist="poisson")
phd.hnb <- hurdle(articles ~ ., data=PhdPubs, dist="negbin")

#' show coefficients
phd.zip
phd.hp

#' ## compare models
LRstats(phd.pois, phd.nbin, phd.zip, phd.znb, phd.hp, phd.hnb, 
        sortby="BIC")

#' ## examine the ZIP model in more detail
#' NB: only mentor is important in the zero model
coeftest(phd.zip)
coeftest(phd.znb)
phd.zip1 <- zeroinfl(articles ~ .| mentor, data=PhdPubs, dist="poisson")
phd.znb1 <- zeroinfl(articles ~ .| mentor, data=PhdPubs, dist="negbin")

summary(phd.zip1)

LRstats(phd.pois, phd.nbin, phd.zip, phd.znb, phd.hp, phd.hnb, phd.zip1, phd.znb1, 
	sortby="BIC")

#' ## effect plot for important terms in the NBIN model

#+ fig.witdh=6, fig.height=4
plot(allEffects(phd.nbin)[c(1,3,5)], rows=1, cols=3)

#' plot the zero model

phd.zero <- glm((articles==0) ~ mentor, data=PhdPubs, family=binomial)
plot(allEffects(phd.zero), main="Mentor effect on not publishing")









          



