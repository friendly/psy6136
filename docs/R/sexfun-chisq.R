#' ---
#' title: "Tests for association in two-way tables"
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

#' ## Load and examine data
library(vcdExtra)
data(SexualFun)
SexualFun                # show the table

#' ## Test association
assocstats(SexualFun)    # association statistics
fisher.test(SexualFun)   # exact test

#' ## Tests for ordered factors
CMHtest(SexualFun)       # CMH tests
