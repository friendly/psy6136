#' ---
#' title: "Assignment 2: Some solutions"
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

#' ## Exercise 2.3

data(UCBAdmissions)
UCB <- UCBAdmissions   # save typing
ftable(UCB)

#' (a) total number of cases
sum(UCB)

#' (b) total applicants for each dept
margin.table(UCB, 3)
apply(UCBAdmissions, 3, sum)

#' (c) proportion admitted for each dept
tab1 <- margin.table(UCB , c(1,3))
tab1
tab1[1,] / margin.table(UCB, 3)
#' or, using prop.table
prop.table(margin.table(UCB, c(1, 3)),2)


#' (d) proportion in each cell admitted
#' There are different ways to do this. Perhaps easiest is to extract the subtables of
#' admitted vs. rejected and divide
admit <- UCB[1,,]
reject <- UCB[2,,]

admit / (admit+reject)

#' ## Exercise 3.1: Arbuthnot data

#' load the data
data(Arbuthnot, package="HistData")

#' (a) Plot `Ratio` vs. `Year`
#' This uses old-school base R features: `plot()`, `abline()`, `loess.smooth()` and `lines()`
plot(Ratio ~ Year, 
     data=Arbuthnot, 
     type="b", 
     ylim=c(1.0,1.2), 
     ylab="M/F Ratio")
abline(h=1.0,col="red",lwd=2)
abline(h=mean(Arbuthnot$Ratio), col="blue")
Arb.sm <- loess.smooth(Arbuthnot$Year, Arbuthnot$Ratio)
lines(Arb.sm, col="blue", lwd=2)

#' using with() evaluates in the environment of a data frame, saves typing Arbuthnot$...
with(Arbuthnot, {
	plot(Ratio ~ Year, 
	     type="b", 
	     ylim=c(1.0,1.2), 
	     ylab="M/F Ratio")
	abline(h=1.0, col="red", lwd=2)
	abline(h=mean(Ratio), col="blue")
	lines(loess.smooth(Year, Ratio), col="blue", lwd=2)
	})

#' ### (b) Total christenings
with(Arbuthnot, {
	Total <- Males + Females
	plot(Total ~ Year, 
	     type="b", 
	     ylab="Total Christenings")
	Arb.sm <- loess.smooth(Year, Total)
	lines(Arb.sm, col="blue", lwd=2)
	})

#' ### Part (a) using `ggplot`
library(ggplot2)
Arbuthnot |>
  ggplot(aes(x=Year, y=Ratio)) +
    geom_point() +
    geom_line() +
    geom_smooth(method = "loess", formula = y~x, color = "blue", fill="blue") +
    geom_hline(yintercept = 1, color = "red", size = 2) +
    geom_hline(aes(yintercept = mean(Ratio)), color = "lightblue", size = 1.5) +
    ylab("Male / Female Ratio")
  

#' ## Exercise 3.3: WomenQueue

#' (a) Barplots
data(WomenQueue, package = "vcd")
barplot(WomenQueue, xlab="Number of Women in Queues of 10 People",
	ylab="Number of Queues", col="pink")

#' (b) Goodness of fit
WQfit1 <- goodfit(WomenQueue, type="binomial", par=list(size=10))
unlist(WQfit1$par)
summary(WQfit1)

#' (c) Plot
plot(WQfit1, type="hanging")

#' ## Exercise 3.4: Saxony data
data(Saxony, package = "vcd")

#' (a) To test goodness of fit of the binomial with an estimated value, $\hat{p}$, only specify max. count, `size` as a parameter
Saxfit <- goodfit(Saxony, type="binomial", par=list(size=12))
unlist(Saxfit$par)
#' The summary() method gives the likelihood ratio test for goodness of fit.
#' $X^2 / df = 97 / 11 = 8.81$ is large (should be $\approx 1$ for a good fitting model).
summary(Saxfit)

#' Plot with a hanging rootogram
plot(Saxfit)


#' (b) To test the model $Bin(n=12, p = 1/2)$, you need to also specify the `prob` parameter
Saxfit1 <- goodfit(Saxony, type="binomial", par=list(size=12, prob=0.5))
unlist(Saxfit1$par)

#' Again, get the GOF test from `summary()`
#' To test for additional lack of fit for the model $Bin(n=12, p = 1/2)$ compared to the model
#' $Bin(n=12, p = \hat{p})$, you have to subtract manually: $\Delta \chi^2 = 205 - 97 = 108$ on 1 df.
summary(Saxfit1)

#' Plot the constrained model with a hanging rootogram
plot(Saxfit1)




