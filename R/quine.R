#' ---
#' title: "Count data models: School absenteeism"
#' author: "Michael Friendly"
#' date: "20 Nov 2017"
#' ---

data("quine", package="MASS")
library(car)       # for Anova()
library(AER)       # dispersiontest
library(lmtest)    # coeftest()
library(effects)   # effect plots

#' ## Fixup the data for ease of use
#'  Age should be treated as an ordered factor; use better labels for `Lrn`
quine$Age <- ordered(quine$Age)
levels(quine$Lrn) <- c("Average", "Slow")

#' ## examine sample sizes in table of predictors
quine.tab <- xtabs(~ Lrn + Age + Sex + Eth, data=quine)
ftable(Age + Sex ~ Lrn + Eth, data=quine.tab)

#' ## Fit model with all predictors
#'  Age should be treated as an ordered factor
quine$Age <- ordered(quine$Age)
quine.mod1 <- glm(Days ~ ., data=quine, family=poisson)
summary(quine.mod1)
Anova(quine.mod1)

#' ## Plot effects
library(effects)
plot(allEffects(quine.mod1), ci.style='bands')

#' ## Test for overdispersion
dispersiontest(quine.mod1)

#' ## Re-fit as quasi-poisson
quine.mod1q <- glm(Days ~ ., data=quine, family=quasipoisson)
coeftest(quine.mod1q)
Anova(quine.mod1q)
#' Visualize effects
plot(allEffects(quine.mod1q), ci.style="bands")


#' ## further analyses: test for interactions
quine.mod2q <- glm(Days ~ .^2, data=quine, family=quasipoisson)

summary(quine.mod2q)
car::Anova(quine.mod2q)

#' Try adding interactions
quine.mod3 <- update(quine.mod1q, . ~ . + Eth:Age)
plot(allEffects(quine.mod3))

quine.mod4 <- update(quine.mod3, . ~ . + Sex:Age)
plot(allEffects(quine.mod4))

#' ## Compare models
anova(quine.mod1q, quine.mod3, quine.mod4, quine.mod2q, test="Chisq")



