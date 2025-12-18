#' ---
#' title: Association diagrams for loglinear models
#' ---

#+ echo=FALSE
knitr::opts_chunk$set(
  warning = FALSE,   # avoid warnings and messages in the output
  message = FALSE
)

#' ## Basic ideas
#' 
#' Exploring the idea of using **association diagrams** for fitting and understanding
#' relationships in high-way categorical data fitted as loglinear models. The essential idea
#' is to try to connect model fit statistics with some visual representation as network diagrams,
#' with nodes representing variables in a model and edges representing pairwise associations.
#' 
#' One realization of this would be a function, say `assocgraph()` that takes a loglinear
#' model (from `MASS::loglm()`, or `glm(, family=poisson)`) and builds the graph object
#' corresponding to **all two-way** terms in the model. A weight for each edge could be obtained
#' using the deviance for that pair, found using either
#' 
#' * `MASS::dropterm()` -- the change in model fit (deviance, LRT) due to dropping each term 
#'    from a given model.
#' * `MASS::addterm()` -- the change in model fit (deviance, LRT) due to adding each two-way
#'    association to the model of mutual independence.
#' 
#' ### Graph packages:
#' 
#' * [`igraph`](https://igraph.org/r/) seems to be the base package for constructing & drawing network diagrams
#' * [`tidygraph`](https://tidygraph.data-imaginist.com/) provides a tidy API for graph/network manipulation
#' * [`ggraph`](https://ggraph.data-imaginist.com/) uses such graph datasets to draw them better, within the `ggplot2` framework.
#' * See also the [CRAN Task View on Graphical Models](https://cran.r-project.org/web/views/GraphicalModels.html),
#'   
#' 
#' ### Tutorials
#' * [Graph analysis using the tidyverse](https://rviews.rstudio.com/2019/03/06/intro-to-graph-analysis/)
#' * [Introduction to Network Analysis with R](https://www.jessesadler.com/post/network-analysis-with-r/) -- a nice tutorial 
#'   on using these packages.
#' 
#' 
#' ### Model fitting:
#' 
#' * `MASS::dropterm()` tries fitting all models that differ from the current model by dropping a single term, maintaining marginality.
#' * `MASS::addterm()` tries fitting all models that differ from the current model by adding a single term, maintaining marginality.
#' * `vcdExtra::Kway()` fits a collection of loglinear models for all 0-, 1-, 2-, ... way associations in a K-way table
#' * `vcdExtra::seq_loglm()` fits various sequential models to the  1-, 2-, ... n-way marginal tables, corresponding to a variety of types of loglinear models.
#'


#' ## Load packages
library(vcdExtra)
library(MASS)     # for loglm(), dropterm()
library(igraph)   # Network Analysis and Visualization
library(ggraph)   # An Implementation of Grammar of Graphics for Graphs and Networks
library(tidygraph)
library(ggplot2)
library(dplyr)

#' ## Load the data
#' This example uses the `DaytonSurvey` dataset, representing a $2^5$ table.
data (DaytonSurvey, package = "vcdExtra")
head(DaytonSurvey)

#' View as a frequency table
Dayton_tab <- xtabs(Freq ~ ., data=DaytonSurvey)
structable(cigarette + alcohol + marijuana ~ sex + race, data=Dayton_tab)



#' ## Model survey
#' A quick survey of loglm models with all 0, 1, 2, 3 way terms
mods <- Kway(Freq ~ cigarette + alcohol + marijuana + sex + race, 
             data = DaytonSurvey, 
             order = 3)

#' ## Test nested models
#' Compare varying order of associations among variables
anova(mods, test="Chisq")

#' ## Summarize these models 
#' `LRstats()` gives AIC, BIC and LR Chisq tests.
LRstats(mods)

#' ## Direct fitting
#' Focusing on the all-twoway model, this could have been fitted directly using
#' the model formula notation.
#' 
mod.2way <- loglm(Freq ~ (cigarette + alcohol + marijuana + sex + race)^2, 
                 data = DaytonSurvey)

#' ## The all two-way model
mods$kway.2

#' ## Find deviance / AIC for all pairwise terms.
#' We can use these as weights for the links in an association graph
(DT <- dropterm(mods$kway.2))

#' Remove the `<none>` model. All we want is the stats for dropping
#' each two-way term.
DT <- DT[-1,]


#' ## Exploring `igraph`
#' 
#' Exploring the ways to use the `igraph` package to visualize associations in 
#' multi-way tables.  

#' Create the full graph of all two-way associations
full <- make_full_graph(5)

#' ## Functions `V()` and `E()`
#' `igraph::V()` and `igraph::E()` are used both to display the node and edge information
#' in a graph, or to assign attributes to them.
#' 
#' vertexes (nodes):
V(full)

#' edges:
E(full)

#' ## `plot()`
#' `igraph::plot()` plots the nodes and edges
plot(full)

#' ### Give nodes the names of the variables
#' The `name` attribute of nodes is special in `igraph`.
#' 
#' For later use, this step assumes that the names assigned to the nodes are in the _same order_
#' as those used in the `loglm()` model.
V(full)$name <- names(DaytonSurvey)[1:5]

V(full)
E(full)

#' ### Node colors
#' make colors correspond to outcomes vs. demographic variables
V(full)$color <- c(rep("orange", 3),
                   rep("lightblue", 2))


#' ### Edge statistics
#' You can also assign arbitrary variables to the edges.
#' 
#' Here, assign deviance and AIC as potential weights for edges
E(full)$deviance <- DT$Deviance
E(full)$aic      <- DT$AIC

E(full)

#' ## Make edge width ~ deviance
#' This is the key step for this visualization.
#' For generality, need a better scheme to translate deviance into the width of the
#' edges.
E(full)$width <- E(full)$deviance/25

#' ## Explore the `igraph` object
#' There are lots of `igraph` functions to get details of a given graph object.
full[]
edge.attributes(full)

#' `ends()` delivers the edges as two-column data.frame
ends(full, es=E(full), names=T) 

#' ## Plot
#' Plot the all two-way model with edge `width ~ deviance`.
#' This uses the `E(full)$width` and `V(full)$color`
#' attributes assigned above. Other attributes can be assigned with optional arguments.
#' 

set.seed(1234)
plot(full, vertex.label.cex=2)


#' ## Try to do this using `ggraph` ???
#' This doesn't work ...
#' 
# ggraph(full) +
#   geom_edge_link(aes(width = DT$Deviance[-1]/25)) + 
#   geom_node_point()

