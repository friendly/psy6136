#' ---
#' title: "Multiple Correspondence Analysis: Pre- and Extra-Marital Sex"
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

#' ## Load the packages and data

library(vcdExtra)  # for mcaplot
library(ca)
data("PreSex", package="vcd")

#' ## Re-order the variables
#' We want the variables in the order G, P, E, M, with marital status last.
PreSex <- aperm(PreSex, 4:1)   # order variables G, P, E, M

#' ## multiple correspondence analysis, using the Burt matrix
presex.mca <- mjca(PreSex, lambda="Burt")
summary(presex.mca)

#' the basic ca::plot() method doesn't do a nice job of labeling
plot(presex.mca)

#' ## vcdExtra::mcaplot does a much nicer job
mcaplot(presex.mca)
# add a nice legend
cols <- c("blue", "red", "brown", "black")
legend("bottomright", legend=c("Gender", "PreSex", "ExtraSex", "Marital"), 
	     title="Factor", 
       title.col="black",
       col=cols, text.col=cols, 
       pch=16:19, 
       bg="gray95", cex=1.2)

