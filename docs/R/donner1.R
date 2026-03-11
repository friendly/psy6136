data("Donner", package="vcdExtra")
str(Donner)

library(car)
set.seed(1235)
some(Donner, 8)

# make survived a factor

Donner$survived <- factor(Donner$survived, labels=c("no", "yes"))

Donner$family.size <- ave(as.numeric(Donner$family), Donner$family, FUN=length)

# recode family
#> xtabs(~family, data=Donner)
#family
#    Breen    Donner      Eddy  FosdWolf    Graves  Keseberg McCutchen MurFosPik 
#        9        14         4         4        10         4         3        12 
#    Other      Reed 
#       23         7 

# collapse small families into "Other"
fam <- Donner$family 
levels(fam)[c(3,4,6,7,9)] <- "Other"
xtabs(~fam)

# reorder, putting Other last

fam = factor(fam,levels(fam)[c(1, 2, 4:6, 3)])
xtabs(~fam)

Donner$family <- fam



# contingency table: use as an exercise in Ch 5
donner.tab <- xtabs(~ survived + sex + cut(age, breaks=seq(0,60,10), right=FALSE), data=Donner)
names(dimnames(donner.tab))[3] <- "age_group"
mosaic(aperm(donner.tab), shade=TRUE)



#xtabs(~survived, data=Donner)
#xtabs(~sex, data=Donner)
#xtabs(~family, data=Donner)

library(gpairs)
library(vcd)
gpairs(Donner[,c(4,2,3,1)],
	diag.pars=list(fontsize=20, hist.color="gray"),
	mosaic.pars=list(gp=shading_Friendly), outer.rot=c(45,45)
	)

library(GGally)
ggpairs(Donner[,c(4,2,3,1)],
         mapping = aes(color = sex, fill = sex, alpha = 0.5)) +
  theme_bw(base_size = 14)

	
#plot(survived ~ family, data=Donner)
# this calls graphics::spineplot
plot(survived ~ family, data=Donner, col=c("pink", "lightblue"))

xtabs(~survived+family, data=Donner)


# conditional density plots

op <- par(mfrow=c(1,2), cex.lab=1.5)
cdplot(survived ~ age, subset=sex=='Male', data=Donner, 
    main="Donner party: Males", ylevels=2:1, ylab="Survived", 
		col=c("pink", "lightblue")[2:1]
    )
	with(Donner, rug(jitter(age[sex=="Male"]), quiet=TRUE))

cdplot(survived ~ age, subset=sex=='Female', data=Donner, 
    main="Donner party: Females", ylevels=2:1, ylab="Survived", 
		col=c("pink", "lightblue")[2:1]
    )
	with(Donner, rug(jitter(age[sex=="Female"]), quiet=TRUE))
par(op)


#############################################################

# ggplots (conditional plots)
library(ggplot2)

# basic plot: survived vs. age, colored by sex, with jittered points
gg <- ggplot(Donner, aes(age, as.numeric(survived=="yes"), color = sex)) + 
  theme_bw() + ylab("Survived") +
	geom_point(position = position_jitter(height = 0.02, width = 0)) 

# add conditional linear logistic regressions
gg + stat_smooth(method = "glm", family = binomial, formula = y ~ x,
                 alpha = 0.2, size = 2, aes(fill = sex))

# add conditional quadratic logistic regressions
gg + stat_smooth(method = "glm", family = binomial, formula = y ~ poly(x,2),
                 alpha = 0.2, size = 2, aes(fill = sex))

# add loess smooth
gg + stat_smooth(method = "loess", span=0.9, alpha = 0.2, size = 2, aes(fill = sex)) +
	coord_cartesian(ylim=c(-.05,1.05))

ggplot(Donner, aes(age, as.numeric(survived=="yes"), color = sex)) + 
  theme_bw() + ylab("Survived") +
	geom_point(position = position_jitter(height = 0.02, width = 0)) +
	stat_smooth(method = "glm", family = binomial, formula = y ~ x,
	alpha = 0.2, size=2, aes(fill = sex))

#including age^2
ggplot(Donner, aes(age, as.numeric(survived=="yes"), color = sex)) + 
  theme_bw() + ylab("Survived") +
	geom_point(position = position_jitter(height = 0.02, width = 0)) +
	stat_smooth(method = "glm", family = binomial, formula = y ~ poly(x,2),
	alpha = 0.2, size=2, aes(fill = sex))

# loess smooth
ggplot(Donner, aes(age, as.numeric(survived=="yes"), color = sex)) + theme_bw() +
	geom_point(position = position_jitter(height = 0.02, width = 0)) +
	stat_smooth(method = "loess", span=0.9, alpha = 0.2, size=2, aes(fill = sex)) +
	coord_cartesian(ylim=c(-.05,1.05))

## put the quadratic & loess together

gg <- ggplot(Donner, aes(age, as.numeric(survived=="yes"), color = sex)) + 
  theme_bw() + ylab("Survived") +
	geom_point(position = position_jitter(height = 0.02, width = 0)) 

gg + stat_smooth(method = "glm", family = binomial, formula = y ~ poly(x,2),
	alpha = 0.2, size=2, aes(fill = sex))

gg + stat_smooth(method = "loess", span=0.9, alpha = 0.2, size=2, aes(fill = sex)) +
	coord_cartesian(ylim=c(-.05,1.05))


library(splines)
ggplot(Donner, aes(age, as.numeric(survived=="yes"), color = sex)) + 
  theme_bw() + ylab("Survived") +
	geom_point(position = position_jitter(height = 0.02, width = 0)) +
	stat_smooth(method = "glm", family = binomial, formula = y ~ ns(x,3),
	alpha = 0.2, size=2, aes(fill = sex))

## fit some models

library(car)

donner.mod0 <- glm(survived ~ age, data=Donner, family=binomial)
summary(donner.mod)

donner.mod1 <- glm(survived ~ age + sex, data=Donner, family=binomial)
Anova(donner.mod1)

donner.mod2 <- glm(survived ~ age * sex , data=Donner, family=binomial)
Anova(donner.mod2)

donner.mod3 <- glm(survived ~ poly(age,2) + sex, data=Donner, family=binomial)
Anova(donner.mod3)

donner.mod4 <- glm(survived ~ poly(age,2) * sex, data=Donner, family=binomial)
Anova(donner.mod4)


# sequential tests
anova(donner.mod1, donner.mod2, donner.mod3, donner.mod4, test="Chisq")

library(vcdExtra)
mods <- glmlist(donner.mod1, donner.mod2, donner.mod3, donner.mod4)
LRstats(mods)
LRstats(donner.mod1, donner.mod2, donner.mod3, donner.mod4)



# table of deviances

mods <- list(donner.mod1, donner.mod2, donner.mod3, donner.mod4)
LR <- sapply(mods, function(x) x$deviance)

#LR <- LRstats(mods)[,1]
LR <- matrix(LR, 2,2)
rownames(LR) <- c("additive", "non-add")
colnames(LR) <- c("linear", "non-lin")
LR<- cbind(LR, diff= LR[,1]-LR[,2])
LR <- rbind(LR, diff= c(LR[1,1:2]-LR[2,1:2],NA))
LR

LR <- cbind(LR, p=pchisq(LR[,3], 1, lower.tail=FALSE))
LR <- rbind(LR, p=c(pchisq(LR[3,1:2], 1, lower.tail=FALSE),NA, NA))
LR

library(xtable)
xtable(LR)


# try splines

library(splines)
donner.mod5 <- glm(survived ~ ns(age,2) * sex, data=Donner, family=binomial)
Anova(donner.mod5)

donner.mod6 <- glm(survived ~ ns(age,4) * sex, data=Donner, family=binomial)
Anova(donner.mod6)

anova(donner.mod5, donner.mod6, test="Chisq")

LRstats(glmlist(donner.mod4, donner.mod5, donner.mod6))



#################################################################
	
library(effects)

#donner.eff <- allEffects(donner.mod4, xlevels=list(age=seq(0,70,5)))


donner.eff3 <- allEffects(donner.mod3, xlevels=list(age=seq(0,50,5)))
plot(donner.eff3, ci.style="bands")


donner.eff4 <- allEffects(donner.mod4, xlevels=list(age=seq(0,50,5)))
plot(donner.eff4, ticks=list(n=8))
plot(donner.eff4, multiline=TRUE, ticks=list(n=8), color=c("red", "blue"), lwd=3, key.args=list(x=.8, y=.9))

plot(donner.eff4, ticks=list(n=8), type="link")


plot(donner.eff)
plot(Effect(c("age", "sex"), donner.mod4))


donner.eff5 <- allEffects(donner.mod5, xlevels=list(age=seq(0,50,5)))
plot(donner.eff5, ticks=list(at=c(0.001, 0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99, 0.999)))

donner.eff6 <- allEffects(donner.mod6, xlevels=list(age=seq(0,50,5)))
#plot(donner.eff6, ticks=list(n=8))
plot(donner.eff6, ticks=list(at=c(0.001, 0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99, 0.999)))


###################################################################

library(rms)

donner.lrm3 <- lrm(survived ~ rcs(age,3) + sex , data=Donner)
anova(donner.lrm3)

donner.lrm4 <- lrm(survived ~ rcs(age,3) * sex , data=Donner)
anova(donner.lrm4)
