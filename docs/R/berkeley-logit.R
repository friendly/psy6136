#' ---
#' title: "UCB data: logit models for admission"
#' author: "Michael Friendly"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: readable
#'     code_download: true
#' ---

library(car)       # for Anova()
library(ggplot2)
library(effects)   # effect plots

#' ## Load the data
data(UCBAdmissions)
berkeley <- as.data.frame(UCBAdmissions)

#' ## Logit model for Dept
berk.logit1 <- glm(Admit=="Admitted" ~ Dept, data=berkeley, 
                 weights=Freq, family="binomial")
Anova(berk.logit1, test="Wald")
summary(berk.logit1)

#' ## Main effects model
berk.logit2 <- glm(Admit=="Admitted" ~ Dept+Gender, 
                 data=berkeley, weights=Freq, family="binomial")
Anova(berk.logit2, test="Wald")
summary(berk.logit2)

#' ## Plots for logit models
obs <- log(UCBAdmissions[1,,] / UCBAdmissions[2,,])
pred2 <- cbind(berkeley[,1:3], fit=predict(berk.logit2))
pred2 <- cbind(subset(pred2, Admit=="Admitted"), obs=as.vector(obs))
head(pred2)

ggplot(pred2, aes(x=Dept, y=fit, group=Gender, color=Gender)) +
  geom_line(size=1.4) +
  geom_point(aes(y=obs), size=3) +
  labs(y="Log odds (Admitted") +
  theme_bw(base_size = 16) +
  theme(legend.position = c(.75, .80))


#' ## Effect plots
berk.eff2 <- allEffects(berk.logit2)

#' plot main  effects
plot(berk.eff2)
# plot 'interaction'
plot(effect('Dept:Gender', berk.logit2), multiline=TRUE)

#' ## include a 1 df term for dept A
berkeley <- within(berkeley, dept1AG <- (Dept=='A')*(Gender=='Female'))
berk.logit3 <- glm(Admit=="Admitted" ~ Dept + Gender + dept1AG, 
                   data=berkeley, weights=Freq, family="binomial")
Anova(berk.logit3, test="Wald")
plot(effect('Dept:Gender', berk.logit3), multiline=TRUE)

obs <- log(UCBAdmissions[1,,] / UCBAdmissions[2,,])
pred3 <- cbind(berkeley[,1:3], fit=predict(berk.logit3))
pred3 <- cbind(subset(pred3, Admit=="Admitted"), obs=as.vector(obs))
head(pred3)

ggplot(pred3, aes(x=Dept, y=fit, group=Gender, color=Gender)) +
  geom_line(size=1.4) +
  geom_point(aes(y=obs), size=3) +
  labs(y="Log odds (Admitted") +
  theme_bw(base_size = 16) +
  theme(legend.position = c(.75, .80))


