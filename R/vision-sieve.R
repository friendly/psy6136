#' ---
#' title: "VisualAcuity data: sieve diagrams"
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


library(vcd)

#' ## View the data
structable(~gender + right + left, data=VisualAcuity)

#' ## Select and process women
women <- subset(VisualAcuity, gender=="female", select=-gender)
structable(~right + left, data=women)
sieve(Freq ~ right + left,  data = women, 
      gp=shading_Friendly, labeling=labeling_values,
      main="Vision data: Women")

#' ## Select and process men
men <- subset(VisualAcuity, gender=="male", select=-gender)
structable(~right + left, data=men)
sieve(Freq ~ right + left,  data = men, 
      gp=shading_Friendly, labeling=labeling_values,
      main="Vision data: Men")

#' ## plot both together
#+ fig.width=8, fig.height=4
cotabplot(Freq ~ right + left | gender, data=VisualAcuity, 
          panel=cotab_sieve, gp=shading_Friendly)

#' ## Some statistical tests for association
chisq.test(xtabs(Freq ~ left + right, data=women))
chisq.test(xtabs(Freq ~ left + right, data=men))

#' mutual independence of gender, right, left
MASS::loglm(Freq ~ gender + right + left, data=VisualAcuity)

