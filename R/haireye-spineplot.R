#' ---
#' title: "Two-way tables: barplots, spineplots and tile plots"
#' author: "Michael Friendly"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: readable
#'     code_download: true
#' ---

library(vcdExtra)

#+ echo=FALSE
knitr::opts_chunk$set(
  warning = FALSE,   # avoid warnings and messages in the output
  message = FALSE
)

#' This example illustrates some alternatives to barplots for contingency tables
#' 
#' ## what's wrong with barplots?
HE <- margin.table(HairEyeColor, 2:1)  # as in Table 4.2
barplot(HE, xlab="Hair color", ylab="Frequency")

#' ## why spineplots are better
#' Show this both ways, with hair and eye color on the horizontal axis
spineplot(HE)
spineplot(t(HE))

#' ## tile plots are also useful
tile(HE)
tile(HE, tile_type="width")
tile(HE, tile_type="height")

#' ## many other variations in fluctile()
#' The extracat package is no longer on CRAN
# if (!require(extracat)) devtools::install_github("heike/extracat")
# library(extracat)
# fluctile(HE)



