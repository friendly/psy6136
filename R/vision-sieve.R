#' ---
#' title: "VisualAcuity data: sieve diagrams"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---

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
cotabplot(Freq ~ right + left | gender, data=VisualAcuity, panel=cotab_sieve, gp=shading_Friendly)
