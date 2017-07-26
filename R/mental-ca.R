#' ---
#' title: "Mental health data: Correspondence analaysis"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---


library(vcdExtra)
library(ca)

#' ## data
data(Mental)
Mental.tab <- xtabs(Freq ~ mental+ses, data=Mental)

#' ## correspondence analysis
ca(Mental.tab)
plot(ca(Mental.tab))


