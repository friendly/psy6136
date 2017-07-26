#' ---
#' title: "Arrests data: Logistic regression"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---

library(effects)    # for Arrests data
library(car)        # for Anova()
library(MASS)       # for stepAIC
data(Arrests)
Arrests$year <- as.factor(Arrests$year)

#' ## all main effects
arrests.mod1 <- glm(released ~ ., family=binomial, data=Arrests)
Anova(arrests.mod1)

#' ## all two-way effects
arrests.mod2 <- glm(released ~ .^2, family=binomial, data=Arrests)
Anova(arrests.mod2)

#' ## backward selection, using AIC
arrests.step <- stepAIC(arrests.mod2, direction="backward")

anova(arrests.mod1, arrests.step, arrests.mod2, test="Chisq")

#' ## one reduced model
arrests.mod <- glm(released ~ employed + citizen + checks + colour*year + colour*age,
 family=binomial, data=Arrests)

#summary(arrests.mod)
Anova(arrests.mod)

anova(arrests.mod1, arrests.mod, arrests.mod2)
anova(arrests.mod1, arrests.mod, arrests.mod2, test="Chisq")



