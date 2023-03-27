#' ---
#' title: Hospital visits: Log-odds analysis
#' ---

library(vcd)
library(vcdExtra)
library(ggplot2)

data(HospVisits, package="vcdExtra")
HospVisits

#' ## Calculate log odds

lodds(HospVisits, response="stay") 

#' Make it into a data.frame, including the ASE
hosp.lodds <- as.data.frame(lodds(HospVisits, response="stay"))

#' ## Fit models
#' Here, I use 1/ASE^2 as the weights, in a weighted least squares
mod.null  <- lm(logodds ~ -1, weights=1/ASE^2, data=hosp.lodds)     # null
mod.const <- lm(logodds ~ 1, weights=1/ASE^2, data=hosp.lodds)      # constant 
mod.unif  <- lm(logodds ~ visit, weights=1/ASE^2, data=hosp.lodds)  # uniform
#' parallel log odds model has a main effect for `stay`
mod.par   <- lm(logodds ~ visit + stay, data=hosp.lodds)

#' Compare model fits
anova(mod.null, mod.const, mod.unif, mod.par)
LRstats(mod.null, mod.const, mod.unif, mod.par)

#' ## Fit models with `visit` as an ordinal factor 
mod1a <- lm(logodds ~ as.numeric(visit), weights=1/ASE^2, data=hosp.lodds)
mod2a <- lm(logodds ~ as.numeric(visit) + stay, weights=1/ASE^2, data=hosp.lodds)
anova(mod.const, mod2a, mod.par)

#' ## Plotting
#' 
#  ## Basic plot of points
gg <- ggplot(hosp.lodds, aes(x=visit, y=logodds, 
                             group=stay, color=stay)) + 
  geom_point(size=5) +
  ylab("log odds of shorter stay\n") + 
  xlab("Visit frequency") + theme_bw() + 
  theme(axis.title = element_text(size = rel(1.5))) + 
  theme(axis.text = element_text(size = rel(1.2))) +
  theme(legend.position = c(.85, .85), 
        legend.background = element_rect(colour = "black")) +
  theme(legend.title = element_text(size=rel(1.3))) +
  theme(legend.text = element_text(size=rel(1.2))) +
  scale_colour_manual(values=c("blue", "red"), 
                      name = "Length of stay")

gg + geom_line(size=1.2, linetype="dotted") 

#' ## showing model fits
grid <- hosp.lodds[,1:2]

#' Make a function to plots lines from a given model
gg_lines <- function(grid, mod, size=1.2, color=NULL, ...) {
  grid$logodds <- stats::predict(mod, grid)
  if(is.null(color)) geom_line(data=grid, size=size, ...) 
  else geom_line(data=grid, size=size, color=color, ...)
}

gg2 <- 	
  gg + gg_lines(grid, mod.null, color="gray", size=1, linetype="dashed") +
  gg_lines(grid, mod.const, color=gray(.5), size=1) +
  gg_lines(grid, mod.unif, color="black", size=1) +
  gg_lines(grid, mod.par)

gg2 + annotate("text", label="null",      x=3.3, y=0, color="gray") +
  annotate("text", label="constant",  x=3.3, y=predict(mod.const, grid)[6], color=gray(.5)) + 
  annotate("text", label="uniform",   x=3.3, y=predict(mod.unif, grid)[6], color="black") +
  annotate("text", label="parallel",  x=3.3, y=hosp.lodds[5:6, 3], color=c("blue", "red")) +
  annotate("text", label="Log odds\nModel",     x=3.3, y=0.6, color="black", size=6)




