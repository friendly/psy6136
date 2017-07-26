#' ---
#' title: "Some R solutions for Assign 1"
#' author: "Michael Friendly"
#' date: "20/01/15 15:48:41"
#' ---

#' ## Exercise 2.2

data(UCBAdmissions)
UCB <- UCBAdmissions   # save typing
ftable(UCB)

sum(UCB)

# total applicants for each dept
margin.table(UCB, 3)
apply(UCBAdmissions, 3, sum)

# proportion admited for each dept
tab1 <- margin.table(UCB , c(1,3))
tab1
tab1[1,] / margin.table(UCB, 3)
# or, using prop.table
prop.table(margin.table(UCB, c(1, 3)),2)


# proportion in each cell admitted
admit <- UCB[1,,]
reject <- UCB[2,,]

admit / (admit+reject)


#'  ## Exercise 2.4

data(UKSoccer, package="vcd")
# total games
sum(UKSoccer)

# marginal totals
addmargins(UKSoccer)
# or
rowSums(UKSoccer)
colSums(UKSoccer)
# or
home <- margin.table(UKSoccer, 1)
away <- margin.table(UKSoccer, 2)

# proportions
prop.table(margin.table(UKSoccer,1))
prop.table(margin.table(UKSoccer,2))


# compare distribution of home & away goals
library(vcd)
goodfit(home, type="poisson")
goodfit(away, type="poisson")
plot(goodfit(home, type="poisson"))
plot(goodfit(away, type="poisson"))

# make a 5 x 2 table
tab <- rbind(home,away)
names(dimnames(tab)) <- c("Team", "Goals")
chisq.test(tab)
mosaic(tab, shade=TRUE)


# mean goals scores-- need to use weighted.mean ...
weighted.mean(0:4, w=home)
weighted.mean(0:4, w=away)
# ... or else expand frequencies to a data frame of 380 games
Home <- rep(0:4, times=home)
Away <- rep(0:4, times=away)
HA <- data.frame(Home, Away)
summary(HA)

boxplot(HA, ylab="Goals scored")

