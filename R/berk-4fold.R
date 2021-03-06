#' ---
#' title: "UCBAdmissions: fourfold displays and odds ratios"
#' author: "Michael Friendly"
#' date: "21 Sep 2017"
#' ---


#' ## Load data
library(vcd)
data("UCBAdmissions")

#' ## rearrange dimensions 
UCB <- aperm(UCBAdmissions, c(2,1,3))
# marginal table, collapsing over Dept
(UCB2 <- margin.table(UCB, c(1,2)))

#' Chisquare test
chisq.test(UCB2)

#' Fourfold plots
fourfold(UCB2)
# unstandardized version
fourfold(UCB2, std="ind.max")

#' ## 3-way table, stratified by Dept
fourfold(UCB, mfrow=c(2,3))

#' ## test homogeneity of odds ratios over Dept
woolf_test(UCB)

#' ## calculate odds ratios
oddsratio(UCBAdmissions, log=FALSE)
# plot log odds ratios
plot(oddsratio(UCBAdmissions), xlab="Department", ylab="Log Odds Ratio (Admit|Gender)")
