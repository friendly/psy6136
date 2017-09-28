#' ---
#' title: "Two-way tables: barplots, spineplots and tile plots"
#' author: "Michael Friendly"
#' date: "27 Sep 2017"
#' ---
library(vcdExtra)

#' ## what's wrong with barplots?
HE <- margin.table(HairEyeColor, 2:1)  # as in Table 4.2
barplot(HE, xlab="Hair color", ylab="Frequency")

#' ## why spineplots are better
spineplot(HE)
spineplot(t(HE))

#' ## tile plots are also useful
tile(HE)
tile(HE, tile_type="width")
tile(HE, tile_type="height")

#' ## many other variations in fluctile()
library(extracat)
fluctile(HE)



