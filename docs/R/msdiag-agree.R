#' ---
#' title: "MSPatients: Agreement"
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

#' Load packages and data
library(vcd)
data(MSPatients, package="vcd")

#' ## Calculate Kappa for each set of patients
#' For the 3-way table, use indexing to select each patient group
Kappa(MSPatients[,,1])
Kappa(MSPatients[,,2])

#' Confidence intervals for Kappa
confint(Kappa(MSPatients[,,1]))
confint(Kappa(MSPatients[,,2]))

#' ## Agreement plots
agreementplot(t(MSPatients[,,1]), main = "Winnipeg Patients")
agreementplot(t(MSPatients[,,2]), main = "New Orleans Patients")
