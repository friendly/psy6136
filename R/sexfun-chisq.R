#' ---
#' title: "Tests for association in two-way tables"
#' author: "Michael Friendly"
#' ---

#' ## Load and examine data
library(vcdExtra)
data(SexualFun)
SexualFun                # show the table

#' ## Test association
assocstats(SexualFun)    # association statistics
fisher.test(SexualFun)   # exact test

#' ## Tests for ordered factors
CMHtest(SexualFun)       # CMH tests
