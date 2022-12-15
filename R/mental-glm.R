#' ---
#' title: "Mental health data: glm() for ordinal variables "
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---

#+ echo=FALSE
knitr::opts_chunk$set(
  warning = FALSE,   # avoid warnings and messages in the output
  message = FALSE
)

#' ## Mental health data
library(gnm)
library(vcdExtra)
library(corrplot)
data(Mental)

#' Display the frequency table
(Mental.tab <- xtabs(Freq ~ mental + ses, data=Mental))

#' ## Fit the independence model
#' Residual deviance: 47.418 on 15 degrees of freedom
indep <- glm(Freq ~ mental+ses,
                family = poisson, data = Mental)
vcdExtra::LRstats(indep)

#' ## Local odds ratios
(LMT <- loddsratio(t(mental.tab)))
corrplot(as.matrix(LMT), method="square", is.corr = FALSE,
         tl.col = "black", tl.srt = 0, tl.offset=1)

#' ## Mosaic plot
long.labels <- list(set_varnames = c(mental="Mental Health Status", ses="Parent SES"))
mosaic(indep, residuals_type="rstandard", labeling_args = long.labels, labeling=labeling_residuals,
       main="Mental health data: Independence")

#' As a sieve diagram
mosaic(indep, labeling_args = long.labels, panel=sieve, gp=shading_Friendly,
       main="Mental health data: Independence")
 
#' ## Fit linear x linear (uniform) association.  
#' Use integer scores for rows/cols 
Cscore <- as.numeric(Mental$ses)
Rscore <- as.numeric(Mental$mental)

#' ## Column effects model (ses)
coleff <- glm(Freq ~ mental + ses + Rscore:ses,
                family = poisson, data = Mental)
mosaic(coleff,residuals_type="rstandard", 
 labeling_args = long.labels, labeling=labeling_residuals, suppress=1, gp=shading_Friendly,
 main="Mental health data: Col effects (ses)")

#' ## Row effects model (mental)
roweff <- glm(Freq ~ mental + ses + mental:Cscore,
                family = poisson, data = Mental)
mosaic(roweff,residuals_type="rstandard", 
 labeling_args = long.labels, labeling=labeling_residuals, suppress=1, gp=shading_Friendly,
 main="Mental health data: Row effects (mental)")
               
#' ## linear x linear model 
linlin <- glm(Freq ~ mental + ses + Rscore:Cscore,
                family = poisson, data = Mental)

#' ## Compare models
anova(indep, roweff, coleff, linlin)
AIC(indep, roweff, coleff, linlin)
            
mosaic(linlin,residuals_type="rstandard", 
 labeling_args = long.labels, labeling=labeling_residuals, suppress=1, gp=shading_Friendly,
 main="Mental health data: Linear x Linear")


#' ###  Goodman Row-Column association model fits well (deviance 3.57, df 8)
Mental$mental <- C(Mental$mental, treatment)
Mental$ses <- C(Mental$ses, treatment)
RC1model <- gnm(Freq ~ mental + ses + Mult(mental, ses),
                family = poisson, data = Mental)

mosaic(RC1model, residuals_type="rstandard",
 labeling_args = long.labels, labeling=labeling_residuals, suppress=1, gp=shading_Friendly,
 main="Mental health data: RC(1) model")
