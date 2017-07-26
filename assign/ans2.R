#' ---
#' title: "Assignment 2: Some solutions"
#' author: "Michael Friendly"
#' date: "27 Jan 2015"
#' ---

#' ## Exercise 2.3: Danish Welfare

library(vcdExtra)
data(DanishWelfare)
str(DanishWelfare)
sum(DanishWelfare$Freq)  # total cases

#' ### Ordering Alcohol and Income
levels(DanishWelfare$Alcohol)
DanishWelfare$Alcohol <- ordered(DanishWelfare$Alcohol, levels=c("<1", "1-2", ">2"))

levels(DanishWelfare$Income)
DanishWelfare$Income <- ordered(DanishWelfare$Income, levels=c("0-50","50-100","100-150",">150"))

#' or, simpler, using as.ordered():
DanishWelfare$Alcohol <- as.ordered(DanishWelfare$Alcohol)
DanishWelfare$Income <- as.ordered(DanishWelfare$Income)

#' now they are **ordered factors**
str(DanishWelfare)

#' ### convert to table form
Danish.tab <- xtabs(DanishWelfare)
# same, using formula method
Danish.tab <- xtabs(Freq ~ ., data=DanishWelfare)

str(Danish.tab)
structable(Danish.tab)

#' ### Urban factor
margin.table(DanishWelfare.tab, 4)

#' Collapse categories
Danish.tab2 <- collapse.table(Danish.tab, Urban=c("City","City","City","City","NonCity"))

structable(Danish.tab2)

structable(Alcohol ~ Urban+Status+Income,  Danish.tab2)

#' ## Exercise 3.1: Arbuthnot data
data(Arbuthnot, package="HistData")

plot(Ratio ~ Year, data=Arbuthnot, type="b", ylim=c(1.0,1.2), ylab="M/F Ratio")
abline(h=1.0,col="red",lwd=2)
abline(h=mean(Arbuthnot$Ratio), col="blue")
Arb.sm <- loess.smooth(Arbuthnot$Year, Arbuthnot$Ratio)
lines(Arb.sm, col="blue", lwd=2)

#' using with() evaluates in the environment of a data frame, saves typing Arbuthnot$...
with(Arbuthnot, {
	plot(Ratio ~ Year, type="b", ylim=c(1.0,1.2), ylab="M/F Ratio")
	abline(h=1.0, col="red", lwd=2)
	abline(h=mean(Ratio), col="blue")
	lines(loess.smooth(Year, Ratio), col="blue", lwd=2)
	})

#' ### Total christenings
with(Arbuthnot, {
	Total <- Males + Females
	plot(Total ~ Year, type="b", ylab="Total Christenings")
	Arb.sm <- loess.smooth(Year, Total)
	lines(Arb.sm, col="blue", lwd=2)
	})

#' ## Exercise 3.3: WomenQueue

data(WomenQueue)
barplot(WomenQueue, xlab="Number of Women in Queues of 10 People",
	ylab="Number of Queues", col="pink")

WQfit1 <- goodfit(WomenQueue, type="binomial", par=list(size=10))
unlist(WQfit1$par)
summary(WQfit1)

plot(WomenQueuefit1, type="hanging")

#' ## Exercise 3.4: Saxony data
data(Saxony)

#' specifying parameters
Saxfit1 <- goodfit(Saxony, type="binomial", par=list(size=12, prob=0.5))
unlist(Saxfit1$par)
summary(Saxfit1)
plot(Saxfit1)

#' only specify max. count
Saxfit2 <- goodfit(Saxony, type="binomial", par=list(size=12))
unlist(Saxfit2$par)
summary(Saxfit2)
plot(Saxfit2)




