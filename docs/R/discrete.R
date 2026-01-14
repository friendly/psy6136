#' ---
#' title: Discrete distributions examples
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

#' ## Code for some examples of discrete distributions
#' 
library(vcdExtra)


data(Federalist, package = "vcd")

Federalist

barplot(Federalist,
        xlab = "Occurrences of 'may",
        ylab = "Number of blocks of text",
        col = "lightgreen",
        cex.lab = 1.5)

data(Butterfly, package="vcd")
barplot(Butterfly,
        xlab = "Number of individuals",
        ylab = "Number of species",
        col = "pink",
        cex.lab = 1.5)



#' ## Males in Saxony families
options(digits=3)   # for printing tables
data(Saxony, package="vcd")
Saxony

Sax.fit <- goodfit(Saxony, type = "binomial", par=list(size=12))
summary(Sax.fit)


Sax.fit    # print

plot(Sax.fit, type = "standing", xlab = "Number of males")

plot(Sax.fit, type = "hanging", xlab = "Number of males")   # default

plot(Sax.fit, type = "deviation", xlab = "Number of males")

#' ## Federalist papers
data(Federalist, package="vcd")
Federalist

#' Fit the Poisson, then neg binomial

Fed.fit0 <- goodfit(Federalist, type="poisson")
summary(Fed.fit0)

Fed.fit1<- goodfit(Federalist, type="nbinomial")
summary(Fed.fit1)

#' ## hanging rootograms

plot(Fed.fit0, main = "Poisson")
plot(Fed.fit1, main = "Negative binomial")


#' ## Ord plots

Ord_plot(Butterfly,
         main = "Butterfly species collected in Malaya", gp=gpar(cex=1), pch=16)


Ord_plot(Saxony, main = "Families in Saxony", gp=gpar(cex=1), pch=16)
Ord_plot(Federalist, main = "Instances of 'may' in Federalist papers", gp=gpar(cex=1), pch=16)

#' ## distplot()

distplot(Federalist, type="poisson", xlab="Occurrences of 'may'",
         lwd = 3)



