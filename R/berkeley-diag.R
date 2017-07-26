#' ---
#' title: "Diagnostic plots for berkeley data"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---

library(car)

#' ## Prepare data frame for plotting
berkeley <- as.data.frame(UCBAdmissions)
cellID <- paste(berkeley$Dept, substr(berkeley$Gender,1,1), '-', 
                substr(berkeley$Admit,1,3), sep="")
rownames(berkeley) <- cellID

#' ## using glm()
berk.mod <- glm(Freq ~ Dept * (Gender+Admit), data=berkeley, family="poisson")
summary(berk.mod)

influencePlot(berk.mod, labels=cellID, id.n=3)

plot(berk.mod)

