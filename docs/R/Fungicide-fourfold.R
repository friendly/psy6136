#' ---
#' title: "Fungicide data: Stratified 2 x 2 tables"
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

library(vcdExtra)
data(Fungicide, package = "vcdExtra")
str(Fungicide)

# rearrange `group` for ease of interpretation, so odds ratio > 1 means worse outcome for Treated group
Fungicide <- Fungicide[2:1, , , ]


ftable(sex + strain ~ outcome + group, data=Fungicide)

fourfold(Fungicide, p_adjust_method="none")

#' ## Get association statistics 
#' Pearson & LR chisq, phi coefficient, ... for the first two dimensions. All others are considered strata
assocstats(Fungicide)


oddsratio(Fungicide) |>
  summary()

loddsratio(Fungicide) |>
  summary()


summary(fung.lor)

plot(fung.lor)

#' ## Homogeneity of association
#' Woolf test only only handles 2 x 2 x k tables
woolf_test(Fungicide)


