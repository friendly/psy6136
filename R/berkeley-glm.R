#' ---
#' title: "UCBAdmissions: Fitting models with loglm() and glm()"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---

library(vcdExtra)
data("UCBAdmissions")

structable(Dept ~ Admit+Gender,UCBAdmissions)

#' ## conditional independence in UCB admissions data
berk.mod1 <- loglm(~ Dept * (Gender + Admit), data=UCBAdmissions)
berk.mod1
mosaic(berk.mod1, gp=shading_Friendly)

#' ## all two-way model
berk.mod2 <-loglm(~(Admit+Dept+Gender)^2, data=UCBAdmissions)
berk.mod2
mosaic(berk.mod2, gp=shading_Friendly)

#' compare models
anova(berk.mod1, berk.mod2, test="Chisq")

##################
#' ## same, using glm() -- need to transform the data to a data.frame

berkeley <- as.data.frame(UCBAdmissions)
berk.glm1 <- glm(Freq ~ Dept * (Gender+Admit), data=berkeley, family="poisson")
summary(berk.glm1)
mosaic(berk.glm1, gp=shading_Friendly, labeling=labeling_residuals, formula=~Admit+Dept+Gender)

# the same, displaying studentized residuals note use of formula to reorder factors in the mosaic
mosaic(berk.glm1, residuals_type="rstandard", labeling=labeling_residuals, shade=TRUE, 
	formula=~Admit+Dept+Gender, main="Model: [DeptGender][DeptAdmit]")

## all two-way model
berk.glm2 <- glm(Freq ~ (Dept + Gender + Admit)^2, data=berkeley, family="poisson")
summary(berk.glm2)
mosaic.glm(berk.glm2, residuals_type="rstandard", labeling = labeling_residuals, shade=TRUE,
	formula=~Admit+Dept+Gender, main="Model: [DeptGender][DeptAdmit][AdmitGender]")
anova(berk.glm1, berk.glm2, test="Chisq")

#' ## Add 1 df term for association of [GenderAdmit] only in Dept A
berkeley <- within(berkeley, dept1AG <- (Dept=='A')*(Gender=='Female')*(Admit=='Admitted'))
berkeley[1:6,]
berk.glm3 <- glm(Freq ~ Dept * (Gender+Admit) + dept1AG, data=berkeley, family="poisson")
summary(berk.glm3)
mosaic.glm(berk.glm3, residuals_type="rstandard", labeling = labeling_residuals, shade=TRUE,
	formula=~Admit+Dept+Gender, main="Model: [DeptGender][DeptAdmit] + DeptA*[GA]")
anova(berk.glm1, berk.glm3, test="Chisq")



