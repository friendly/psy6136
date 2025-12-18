#' ---
#' title: "VisualAcuity: Quasi-independence and quasi-symmetry"
#' author: "Michael Friendly"
#' output:
#'   html_document:
#'     theme: readable
#'     code_download: true
#' ---

#+ echo=FALSE
knitr::opts_chunk$set(
  warning = FALSE,   # avoid warnings and messages in the output
  message = FALSE
)

#' ## Load packages & data
library(vcdExtra)
library(gnm)      # for Diag(), Symm()

data(VisualAcuity, package="vcd")

#' ## Work with the data for females
women <- subset(VisualAcuity, gender=="female", select=-gender)

#' ## Fit the independence model
indep <- glm(Freq ~ right + left,  data = women, family=poisson)
mosaic(indep, residuals_type="rstandard", gp=shading_Friendly,
       main="Vision data: Independence (women)"  )

#' ## Quasi-independence: ignore the diagonal cells by fitting them exactly

quasi.indep <- glm(Freq ~ right + left + Diag(right, left), 
       data = women, family = poisson)
mosaic(quasi.indep, residuals_type="rstandard", gp=shading_Friendly,
       main="Quasi-Independence (women)"  )

#' ##  Symmetry:  test F[i,j] = F[j,i].  
#' Note that this model does not include the 'main' effects of right and left, so assumes marginal homogeneity

symmetry <- glm(Freq ~ Symm(right, left), 
       data = women, family = poisson)
mosaic(symmetry, residuals_type="rstandard", gp=shading_Friendly,
       main="Symmetry model (women)"  )

#' ## Quasi-symmetry: allow different marginal frequencies for left and right

quasi.symm <- glm(Freq ~ right + left + Symm(right, left), 
       data = women, family = poisson)
mosaic(quasi.symm, residuals_type="rstandard", gp=shading_Friendly,
       main="Quasi-Symmetry model (women)")

#' ## Model comparisons: for *nested* models
anova(indep, quasi.indep, quasi.symm, test="Chisq")
anova(symmetry, quasi.symm, test="Chisq")

#' ## model summaries, with AIC and BIC
models <- glmlist(indep, quasi.indep, symmetry, quasi.symm)
LRstats(models)
