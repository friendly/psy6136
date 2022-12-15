#' ---
#' title: "Mental health data: Correspondence analysis"
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
library(ca)

#' ## data
data(Mental, package = "vcdExtra")
Mental.tab <- xtabs(Freq ~ mental+ses, data=Mental)

#' ## correspondence analysis
ca(Mental.tab)

#' ## Plot the ca solution
plot(ca(Mental.tab), lines = TRUE)


