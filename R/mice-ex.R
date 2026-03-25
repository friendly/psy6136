#' ---
#' title: "Mice data: log odds analysis"
#' author: "Michael Friendly"
#' date: "22 Jul 2015"
#' ---


library(vcdExtra)

mice.tab <- xtabs(Freq ~ litter + treatment + deaths, data=Mice)

#' ## Calculate log odds for contrasts among deaths
# reshape table to matrix
T <- matrix(mice.tab, 
            nrow=prod(dim(mice.tab)[1:2]), 
            ncol=dim(mice.tab)[3])
colnames(T) <- dimnames(mice.tab)[[3]]
rn <- expand.grid(dimnames(mice.tab)[1:2])
rownames(T) <- apply(rn, 1, paste, collapse=":")
T
# calculate log odds as contrasts
C <- matrix(c(1, -1, 0,
              0,  1, -1), nrow=3)
lodds <- log(T) %*% C
colnames(lodds) <- c("0:1", "1:2+")
lodds

#' For analysis, we want this as a data frame, with factors
mice.lodds <- data.frame(expand.grid(litter=factor(7:11), treatment=c("A","B"), deaths=c("0:1", "1:2+")), 
	logodds=c(lodds))
mice.lodds		


# using vcd::lodds
lodds(mice.tab, response="deaths")
(mice.lodds <- as.data.frame(lodds(mice.tab, response="deaths")))

#' ## fit models 
library(car)

# null model
mod0 <- lm(logodds ~ 1, data=mice.lodds)
mod1 <- lm(logodds ~ litter + treatment, data=mice.lodds)
# uniform log odds
mod2 <- lm(logodds ~ litter * treatment, data=mice.lodds)
# parallel log odds
mod3 <- lm(logodds ~ litter * treatment + deaths, data=mice.lodds)
Anova(mod3)
anova(mod0, mod1, mod2, mod3)

## use WLS
mod0 <- lm(logodds ~ 1, weights=1/ASE^2, data=mice.lodds)
mod1 <- lm(logodds ~ litter + treatment, weights=1/ASE^2, data=mice.lodds)
# uniform log odds
mod2 <- lm(logodds ~ litter * treatment, weights=1/ASE^2, data=mice.lodds)
# parallel log odds
mod3 <- lm(logodds ~ litter * treatment + deaths, weights=1/ASE^2, data=mice.lodds)

Anova(mod3)
anova(mod0, mod1, mod2, mod3)

# can we treat litter size as numeric?
mod3.lin <- lm(logodds ~ as.numeric(litter) * treatment + deaths, weights=1/ASE^2, data=mice.lodds)
anova(mod3.lin, mod3)


### analogous loglm models
library(MASS)
# Goodman parallel log odds model, M5
loglm(~ litter*treatment + deaths, mice.tab)

#' ## Plots 

mosaic(mice.tab, shade=TRUE, expected=~litter*treatment+deaths)

library(ggplot2)

#' basic plot of points
gg <- ggplot(mice.lodds, aes(x=litter, y=logodds, color=deaths, group=deaths)) + 
	geom_point(size=4) +   
	ylab("log odds of fewer deaths\n") + 
	xlab("Litter size") + theme_bw() + 
	theme(axis.title = element_text(size = rel(1.5))) + 
	theme(axis.text = element_text(size = rel(1.2))) +
	theme(legend.position = c(.9, .85), legend.background = element_rect(colour = "black")) +
	facet_grid(. ~ treatment, labeller=label_both) +
	theme(strip.text = element_text(size = rel(1.2)))

#' data plot
#gg + geom_line(size=1.2) 

#' add error bars
bars <- aes(ymin=logodds-ASE, ymax=logodds+ASE)
#dodge <- position_dodge(width=.2)
gg + geom_line(size=1.2) +
     geom_errorbar(bars, width=0.25, size=1, position=position_dodge(width=.2))


cd("C:/Dropbox/Documents/Presentations/carme2015/fig")
#dev.copy2pdf(file="mice-odds0.pdf")  
ggsave("mice-odds0.pdf")


#' add linear smoother: separate lines for each factor combination
#' This is equalvalent to the model with a three-way term, as.numeric(litter)*treatment*deaths
gg  + geom_smooth(method="lm", se=TRUE, size=1.2, aes(fill=deaths), alpha=0.25)
#' Should use weighted regressions -- it makes a small difference here
gg  + geom_smooth(method="lm", se=TRUE, size=1.2, aes(fill=deaths, weight=1/ASE^2), alpha=0.25)
#dev.copy2pdf(file="mice-odds-lin.pdf")  
ggsave("mice-odds-lin.pdf")



gg  + geom_smooth(se=TRUE, size=1.2, aes(fill=deaths), alpha=0.25)

# showing model fits
pred <- mice.lodds[,1:3]
pred$logodds <- predict(mod3, pred)
gg + geom_line(data=pred, size=1.2)

pred$logodds <- predict(mod2, pred)
gg + geom_line(data=pred, size=1.2, color="black")


pred$logodds <- predict(mod1, pred)
gg + geom_line(data=pred, size=1.2, color="black")

pred$logodds <- predict(mod0, pred)
gg + geom_line(data=pred, size=1.2, color="gray")

gg_lines <- function(mod, grid, size=1.2, color=NULL, ...) {
	grid$logodds <- predict(mod, grid)
	if(is.null(color)) geom_line(data=grid, size=size, ...) else geom_line(data=grid, size=size, color=color, ...)
	}

gg + gg_lines(mod3, pred) +
     gg_lines(mod0, pred, color=gray(.5), size=1, linetype="dashed")
#dev.copy2pdf(file="mice-odds-mod3.pdf")  

#gg_predict <- function(grid, mod, size=1.2, color=NULL, se=FALSE, ...) {
#	grid$logodds <- predict(mod, grid)
#	if (se) {
#		pred <- predict(mod, grid, se=TRUE)
#		grid <- transform(grid, logodds=pred$fit, 
#		                        lwr=pred$fit - pred$se.fit,
#		                        upr=pred$fit + pred$se.fit)
#	}
#	else {
#		grid$logodds <- predict(mod, grid)
#	}
#	res <- NULL
#	if(is.null(color)) 
#		res <- geom_line(data=grid, size=size, ...) else geom_line(data=grid, size=size, color=color, ...)
#	if(se) res <- res + geom_ribbon(data=grid, aes(ymin=lwr, ymax=upr), alpha=0.3)
#	res
#	}

gg_band <- function(mod, grid, color=NULL, ...) {
		pred <- predict(mod, grid, se=TRUE)
		grid <- transform(grid, logodds=pred$fit, 
		                        lwr=pred$fit - pred$se.fit,
		                        upr=pred$fit + pred$se.fit)
	  geom_ribbon(data=grid, aes(ymin=lwr, ymax=upr, fill=deaths), alpha=0.3)
}

gg + gg_band(mod3, pred) + gg_lines(mod3, pred)

gg + gg_band(mod2, pred) + gg_lines(mod2, pred)

### Different approach: just get predicted values and then use geom_ribbon(), geom_line() directly

predict_CI <- function (model, newdata, response, level=0.68) {
	pred <- stats::predict(model, newdata,	interval="confidence", level=level)
	if (!missing(response)) colnames(pred)[1] <- response
	cbind(newdata, pred)
}

pred2 <- predict_CI(mod2, mice.lodds[,1:3], "logodds")
gg + geom_ribbon(data=pred2, aes(ymin=lwr, ymax=upr), alpha=0.1) +
     geom_line(data=pred2, size=1.2, color="black")
ggsave("mice-odds-mod2.pdf")


pred3 <- predict_CI(mod3, mice.lodds[,1:3], "logodds")
gg + geom_ribbon(data=pred3, aes(ymin=lwr, ymax=upr, fill=deaths), alpha=0.2) +
     geom_line(data=pred3, size=1.2)
ggsave("mice-odds-mod3.pdf")

pred3.lin <- predict_CI(mod3.lin, mice.lodds[,1:3], "logodds")
gg + geom_ribbon(data=pred3.lin, aes(ymin=lwr, ymax=upr, fill=deaths), alpha=0.2) +
     geom_line(data=pred3.lin, size=1.2)
ggsave("mice-odds-mod3-lin.pdf")
