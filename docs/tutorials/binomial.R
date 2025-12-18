#' ---
#' title: "Binomial distributions"
#' author: "Michael Friendly"
#' date: "`r format(Sys.Date())`"
#' ---

#' Here are some simple examples of working with binomial distributions. The motivating example is
#' `vcd::WeldonDice`, reporting the frequencies of obtaining a 5 or 6 in throws of 12 dice. If the
#' dice were fair, this should give a binomial distribution, Bin(12, 1/3).

library(vcd)
library(lattice)
library(ggplot2)

data(WeldonDice, package = "vcd")
WeldonDice

#' ### plot Bin(12, 1/3), like Weldon's dice
#' The `dbinom()` function calculates the probabilities in a binomial, Bin(n, p) for a range of `x` values.
x <- seq(0,12)
plot(
  x = x,
  y = dbinom(x, 12, 1 / 3),
  type = "h",
  lwd = 8
)

#' ## Do the same, with better labels, and `lines()`
x <- seq(0,12)
plot(
  x = x,
  y = dbinom(x, 12, 1 / 3),
  type = "h",
  xlab = "Number of successes",
  ylab = "Probability",
  lwd = 8,
  lend = "square"
)
lines(x=x, y=dbinom(x,12,1/3))

#' ## Calculate expected frequencies & contributions to $\chi^2$
#' There's a wrinkle here, in that the data reported in `WeldonDice` for `x=10` represents the
#' frequency for 10 or more 5s or 6s.
data(WeldonDice, package="vcd")
Weldon.df <- as.data.frame(WeldonDice)   # convert to data frame

x <- seq(0,12)
Prob <- dbinom(x, 12, 1/3)               # binomial probabilities
Prob <- c(Prob[1:10], sum(Prob[11:13]))  # sum values for 10+
Exp  <- round(sum(WeldonDice)*Prob)         # expected frequencies
Diff <- Weldon.df[,"Freq"] - Exp          # raw residuals
Chisq = Diff^2 /Exp
data.frame(Weldon.df, Prob=round(Prob,4), Exp, Diff, Chisq)

#' ## Use `vcd::goodfit()` 
#' `vcd::goodfit()` calculates probabilities, fitted values and residuals for a given
#' distribution type.  The `plot()` method for a `goodfit` object gives a `rootogram()`.
#' 
goodfit(WeldonDice, type = "binomial", par = list(size=12)) |> plot()

#' ## Plotting binomial distributions

#' ### create a set of binomial distributions, Bin(12, p)
# `dbinom()` can take vector inputs for the parameters

x <- seq(0,12)                # values of x
p <- c(1/6, 1/3, 1/2, 2/3)    # values of p
x <- rep(x, 4)                # replicate, length(p) times
p <- rep(p, each=13)          # replicate, each length(x)
bin.df <- data.frame(x, prob = dbinom(x, 12, p), p)
bin.df$p <- factor(bin.df$p, labels=c("1/6", "1/3", "1/2", "2/3"))
str(bin.df)

#' ## Better version: using `expand.grid()`

XP <-expand.grid(x=0:12, p=c(1/6, 1/3, 1/2, 2/3))
bin.df <- data.frame(XP, prob=dbinom(XP[,"x"], 12, XP[,"p"]))
bin.df$p <- factor(bin.df$p, labels=c("1/6", "1/3", "1/2", "2/3"))
str(bin.df)

#' ### Using `lattice::xyplot()` to plot the distributions
#' 
#' With lattice, the `groups = p` argument gives a separate line for each level of `p`.
#' `pch` and `col` arguments set the point symbols and colors.
#' The `key` argument is used to define the legend for the plot.
#' 
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

#' ## The same, using `ggplot2`
#' For this plot, to give separate curves for each level of `p`, I assign this to both
#' the `color` & `shape` aesthetics.

library(ggplot2)
ggplot(bin.df, aes(x = x, y = prob, color = p, shape = p)) +
  geom_point(size=4) +
  geom_line(linewidth = 1.25) +
  labs(x = "Number of successes",
       y = "Probability") +
  scale_colour_discrete("Pr(success)") +
  scale_shape_discrete("Pr(success)") +
  theme_bw(base_size = 16) +
  theme(legend.position = c(0.8, 0.8))


