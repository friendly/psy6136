#' ---
#' title: "RScript Template"
#' author: "Your Name"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: readable
#'     code_download: true
#'   word_document: default
#' ---

#+ echo=FALSE
knitr::opts_chunk$set(
  warning = FALSE,   # avoid warnings and messages in the output
  message = FALSE    # with FALSE, they appear in the console
)

#' This is a sample R script, formatted so that you can use `File -> Compile Report` or
#' `Ctrl+Shift+K` to run analyses and turn it into an HTML document, or a Word document.
#' The general rule is that everything is just R code, but comments that begin with
#' `#'` are treated as text in the output.
#' 
#' * I use section headers, `#' ## Section` to break the script into sections and provide
#' other explanation. 
#' 
#' * All other Rmarkdown constructs apply. E.g., these lines are a bullet list.
#' 
#' ## Load packages
#' Generally, I find it useful to load all packages I'm using at the beginning of a script.
library(vcdExtra)   # for data and graphics

#' ## Load data
#' Illustrate the `Abortion` data. For details: `help(Abortion, package = "vcdExtra")`.
data(Abortion, package = "vcdExtra") 

#' Look at what's there. The `Abortion` table has `r sum(Abortion)` observations.
str(Abortion)

#' ## Print the table nicely
#' `ftable()` flattens the table to a two-way display, with some variables assigned to the rows
#' and others assigned to the columns.
ftable(Abortion)

#' ## Make a plot
#' I want to make a fourfold plot of `Status` by `Support_Abortion` each level of `Sex`
fourfold(aperm(Abortion, 3:1))