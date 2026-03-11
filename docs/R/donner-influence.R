data("Donner", package="vcdExtra")

# make survived a factor
Donner$survived <- factor(Donner$survived, labels=c("no", "yes"))


#####################################################
# use this

donner.mod3 <- glm(survived ~ poly(age,2) + sex, data=Donner, family=binomial)
op <- par(mfrow=c(2,2), mar=c(5,4,2,1)+.1, cex.lab=1.2)
plot(donner.mod3)
par(op)

# show all 6 plots
caption = list("(1) Residuals vs Fitted", 
               "(2) Normal Q-Q",
               "(3) Scale-Location", 
               "(4) Cook's distance",
               "(5) Residuals vs Leverage",
               expression("(6) Cook's dist vs Leverage  "
                          * h[ii] / (1 - h[ii])))
op <- par(mfrow=c(3,2), mar=c(5,4,2,1)+.1, cex.lab=1.25, cex=1)
plot(donner.mod3, which=1:6, caption=caption)
par(op)


# residual - leverage plot
plot(donner.mod3, which=5, cex.id=1, cook.levels=c(0.25, 0.5), id.n=3)
abline(h=c(-2, 2), col="gray")
k <- length(coef(donner.mod3))
n <- nrow(Donner)
abline(v=c(2, 3)*k/n, col="gray")
text(x=c(2, 3)*k/n, y=-2.3, c("2k/n", "3k/n"))

library(car)
op <- par(mar=c(5,4,1,1)+.1, cex.lab=1.2)
res <- influencePlot(donner.mod3, id.col="blue", scale=8, id.n=2)
k <- length(coef(donner.mod3))
n <- nrow(Donner)
text(x=c(2, 3)*k/n, y=-1.8, c("2k/n", "3k/n"), cex=1.2)
par(op)

idx <- which(rownames(Donner) %in% rownames(res))
# show data together with diagnostics
cbind(Donner[idx,2:4], res)

influenceIndexPlot(donner.mod3, vars=c("Cook", "Studentized", "hat"), id.n=4)

infl.mod3 <- influence.measures(donner.mod3)
summary(infl.mod3)


plot(donner.mod3, which=6, cex.id=1, cook.levels=c(0.25, 0.5), id.n=3)



#####################################################


donner.mod1 <- glm(survived ~ age + sex, data=Donner, family=binomial)

op <- par(mfrow=c(2,2))
plot(donner.mod1)
par(op)

plot(donner.mod1, which=5, cex.id=1, cook.levels=c(0.25, 0.5))
abline(h=c(-2, 2), col="gray")
k <- length(coef(donner.mod1))
n <- nrow(Donner)
abline(v=c(2, 3)*k/n, col="gray")
text(x=c(2, 3)*k/n, y=-2.3, c("2k/n", "3k/n"), col="gray")

library(car)
#cols <- c("red", "blue")[1+(Donner$sex=="Male")]
res <- influencePlot(donner.mod1, id.col="blue", scale=8)

idx <- which(rownames(Donner) %in% rownames(res))

# show data together with diagnostics
cbind(Donner[idx,2:4], res)

#####################################################

donner.mod2 <- glm(survived ~ age * sex , data=Donner, family=binomial)

op <- par(mfrow=c(2,2))
plot(donner.mod2)
par(op)

plot(donner.mod2, which=5, cex.id=1, cook.levels=c(0.25, 0.5))
abline(h=c(-2, 2), col="gray")
k <- length(coef(donner.mod2))
n <- nrow(Donner)
abline(v=c(2, 3)*k/n, col="gray")
text(x=c(2, 3)*k/n, y=-2.3, c("2k/n", "3k/n"), col="gray")

res <- influencePlot(donner.mod2, id.col="blue", scale=8)
idx <- which(rownames(Donner) %in% rownames(res))
# show data together with diagnostics
cbind(Donner[idx,2:4], res)


#####################################################

donner.mod4 <- glm(survived ~ poly(age,2) * sex, data=Donner, family=binomial)
#Anova(donner.mod4)

op <- par(mfrow=c(2,2))
plot(donner.mod4)
par(op)
# residual - leverage plot
plot(donner.mod4, which=5, id.n=2)

library(car)
res <- influencePlot(donner.mod4, id.col="red", scale=8)

# - doesn't make much sense to use this
library(rms)
donner.lrm1 <- lrm(survived ~ age + sex, data=Donner, x=TRUE, y=TRUE)
infl <- which.influence(donner.lrm1, cutoff=0.3)

dffits <- resid(donner.lrm1, 'dffits')
cookd <- cooks.distance(donner.mod1)
show.influence(infl, dframe=data.frame(Donner, dffits, cookd), report=c("sex", "survived", "dffits", "cookd"))



