#' ---
#' title: "VisualAcuity: Quasi-independence and quasi-symmetry"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---


#' ## Load datra
library(vcdExtra)
library(gnm)
women <- subset(VisualAcuity, gender=="female", select=-gender)

indep <- glm(Freq ~ right + left,  data = women, family=poisson)
mosaic(indep, residuals_type="rstandard", gp=shading_Friendly,
       main="Vision data: Independence (women)"  )

#' ## Quasi-independence: ignore the diagonal cells by fitting them exactly

quasi.indep <- glm(Freq ~ right + left + Diag(right, left), 
       data = women, family = poisson)
mosaic(quasi.indep, residuals_type="rstandard", gp=shading_Friendly,
       main="Quasi-Independence (women)"  )

#' ##  Symmetry:  test F[i,j] = F[j,i].  
#' Note that the model does not include the 'main' effects of right and left, so assumes marginal homogeneity

symmetry <- glm(Freq ~ Symm(right, left), 
       data = women, family = poisson)
mosaic(symmetry, residuals_type="rstandard", gp=shading_Friendly,
       main="Symmetry model (women)"  )

#' ## Quasi-symmetry: allow different marginal frequencies for left and right

quasi.symm <- glm(Freq ~ right + left + Symm(right, left), 
       data = women, family = poisson)
mosaic(quasi.symm, residuals_type="rstandard", gp=shading_Friendly,
       main="Quasi-Symmetry model (women)")

#' model comparisons: for *nested* models
anova(indep, quasi.indep, quasi.symm, test="Chisq")
anova(symmetry, quasi.symm, test="Chisq")

#' model summaries, with AIC and BIC
models <- glmlist(indep, quasi.indep, symmetry, quasi.symm)
LRstats(models)
