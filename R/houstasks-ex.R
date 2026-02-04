#' ---
#' title: housetasks: Correspondence analysis
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

#' ## Load packages and the data
library(FactoMineR)       # Multivariate Exploratory Data Analysis: CA()
library(factoextra)       # Visualize Results of Multivariate Data Analyses: fviz_*()
library(vcdExtra)         # 'vcd' Extensions and Additions: color_table()
library(gplots)           # Tools for Plotting Data: balloonplot()

data(housetasks, package = "factoextra")
str(housetasks)

#' ## Convert the data.frame to a table
#' First make it a matrix, then convert that to a `"table"` object
dt <- as.matrix(housetasks) |>
  as.table()
#' Assign factor names to the table dimensions
names(dimnames(dt)) <- c("Task", "Who_does?")
dt


#' ## Semi-graphical tables
#' 
#' `gplots::balloonplot()` makes plots of frequency data with the size ~ frequency. The calculation of `dotsize`
#' looks a little strange. It is base on a multiple of the size of the bubble symbol, which is `pch = 19`.
#' It plots the cell frequencies as labels
balloonplot(t(dt), main ="housetasks data: Who does What?", 
            dotsize = 5/max(strwidth(19),strheight(19)),
            label.size = 1.5,
            xlab ="", ylab="",
            show.margins = FALSE)

vcdExtra::color_table(dt)


#' ## test for association
chisq.test(housetasks)

#' ## Do the CA
#' FactomineR::CA() does the analysis and can produce CA plots. But these are better done in `factoextra`, so are
#' suppressed here.
house.ca <- CA(housetasks, graph = FALSE)

#' The `print()` method for `"CA"` objects is weird. It simply prints a list of the names of the components.
print(house.ca)

#' The `summary()` method prints something more sensible
summary(house.ca, ncp = 2)

#' ## Visualizations
#' 
#' Visualize variance proportions (screeplot)
#' How many dimensions are necessary to describe association here?
fviz_screeplot(house.ca, 
               addlabels = TRUE, ylim = c(0, 50),
               ggtheme = theme_minimal(base_size = 16))


#' ## Biplot
#' The biplot shows the row and column categories in the 2D space.
#  I use `repel= TRUE` to avoid text overlapping. And chose to show the "who does?" dimension coordinates using
#  arrows from the origin.
fviz_ca_biplot(house.ca, 
               repel = TRUE,
               labelsize = 6,
               arrows = c(FALSE, TRUE),
               title = "Housetasks Symmetric Biplot (principal coordinates)"
               ) +
   theme(
    title = element_text(size = 18),  # Axis title size
    axis.title = element_text(size = 14))  # Axis title size


#' ## Examine row contributions

house.row <- get_ca_row(house.ca)
house.row

house.row$coord

house.row$contrib

