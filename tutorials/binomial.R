#' ---
#' title: "binomial distributions"
#' author: "Michael Friendly"
#' date: "19/01/15 11:32:35"
#' ---

#' ### plot Bin(12, 1/3), like Weldon's dice
x <- seq(0,12)
plot(x=x, y=dbinom(x,12,1/3), type="h", lwd=8)

#' better labels, and lines()
x <- seq(0,12)
plot(x=x, y=dbinom(x,12,1/3), type="h", 
	xlab="Number of successes", ylab="Probability",
	lwd=8, lend="square")
lines(x=x, y=dbinom(x,12,1/3))

#' use Weldon's dice data, calculate expected frequencies
data(WeldonDice, package="vcd")
Weldon.df <- as.data.frame(WeldonDice)   # convert to data frame

Prob <- dbinom(x, 12, 1/3)               # binomial probabilities
Prob <- c(Prob[1:10], sum(Prob[11:13]))  # sum values for 10+
Exp= round(sum(WeldonDice)*Prob)         # expected frequencies
Diff = Weldon.df[,"Freq"] - Exp          # raw residuals
Chisq = Diff^2 /Exp
data.frame(Weldon.df, Prob=round(Prob,6), Exp, Diff, Chisq)

#' ### create a set of binomial distributions, Bin(12, p)
# dbinom can take vector inputs for the parameters

x <- seq(0,12)                # values of x
p <- c(1/6, 1/3, 1/2, 2/3)    # values of p
x <- rep(x, 4)                # replicate, length(p) times
p <- rep(p, each=13)          # replicate, each length(x)
bin.df <- data.frame(x, prob = dbinom(x, 12, p), p)
bin.df$p <- factor(bin.df$p, labels=c("1/6", "1/3", "1/2", "2/3"))
str(bin.df)

#' best version: using expand.grid()

XP <-expand.grid(x=0:12, p=c(1/6, 1/3, 1/2, 2/3))
bin.df <- data.frame(XP, prob=dbinom(XP[,"x"], 12, XP[,"p"]))
bin.df$p <- factor(bin.df$p, labels=c("1/6", "1/3", "1/2", "2/3"))
str(bin.df)

#' ### Using lattice::xyplot() to plot the distributions

library(lattice)

mycol <- palette()[2:5]
xyplot( prob ~ x, data=bin.df, groups=p,
	xlab=list('Number of successes', cex=1.25),
	ylab=list('Probability',  cex=1.25),
	type='b', pch=15:17, lwd=2, cex=1.25, col=mycol,
	key = list(
					title = 'Pr(success)',
					points = list(pch=15:17, col=mycol, cex=1.25),
					lines = list(lwd=2, col=mycol),
					text = list(levels(bin.df$p)),
					x=0.9, y=0.98, corner=c(x=1, y=1)
					)
	)

