#' ---
#' title: "Multiple Correspondence Analysis: Pre- and Extra-Marital Sex"
#' author: "Michael Friendly"
#' date: "12 Oct 2017"
#' ---

#+ echo=FALSE
knitr::opts_chunk$set(
  warning = FALSE,   # avoid warnings and messages in the output
  message = FALSE
)

#' ## Load the data

library(vcdExtra)
library(ca)
data("PreSex", package="vcd")
PreSex <- aperm(PreSex, 4:1)   # order variables G, P, E, M

#' ## multiple correspondence analysis, using the Burt matrix
presex.mca <- mjca(PreSex, lambda="Burt")
summary(presex.mca)

# the basic ca::plot() method doesn't do a nice job of labeling
plot(presex.mca)

#' ## vcdExtra::mcaplot does a much nicer job
mcaplot(presex.mca)

# add a nice legend
cols <- c("blue", "red", "brown", "black")
legend("bottomright", legend=c("Gender", "PreSex", "ExtraSex", "Marital"), 
	title="Factor", title.col="black",
	col=cols, text.col=cols, pch=16:19, 
	bg="gray95", cex=1.2)

