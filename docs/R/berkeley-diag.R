#' ---
#' title: "Diagnostic plots for berkeley data"
#' author: "Michael Friendly"
#' date: "`r format(Sys.Date())`"
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

library(car)

#' ## Prepare data frame for plotting
berkeley <- as.data.frame(UCBAdmissions)
cellID <- paste(berkeley$Dept, substr(berkeley$Gender,1,1), '-', 
                substr(berkeley$Admit,1,3), sep="")
rownames(berkeley) <- cellID

#' ## using glm()
berk.mod <- glm(Freq ~ Dept * (Gender+Admit), data=berkeley, family="poisson")
summary(berk.mod)

#' ## Influence plot
influencePlot(berk.mod, id=list(n=3, labels=cellID))

op <- par(mfrow = c(2,2))
plot(berk.mod)
par(op)