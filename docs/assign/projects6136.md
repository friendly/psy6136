# 6136 Individual or Team Projects

Here is a sketch of a couple of ideas that could be used for course evaluation
replacing some of the components I had planned. You can work on one of these
individually or with a partner. I would expect something more substantial for
a team project than an individual one. 

## Recent developments in Categorical Data Analysis

Compile a list of recent research papers illustrating interesting applications, 
modelling developments, graphical methods, ... of categorical data analysis,
attempting to go beyond what is covered in the course or my book.

Each should have a bibliographical citation, brief description, why it is
interesting or novel. Perhaps with subject / content / method tags or
catrgories.

It could also be in the form of a methods review paper, with the title of
this section, and sufficient text description to give an overview of this
topic. Taking it further, something like this might be publishable, or
certainly a nice blog post.

## Tidy CDA / Extending vcdExtra

Categorical data simple for some purposes, but notoriously "untidy" --
`table()`, `matrix()`, `array()`, `xtabs()`, ... and many functions for analysis
or graphics accept data in a limited varieties of forms.  

[Chapter 2 in DDAR](VCDR/chapter02.pdf) describes the essential ideas for working with
and manipulating catgegorical data, largely within base-R. The `vcdExtra` vignette,
[Creating and manipulating frequency tables](https://friendly.github.io/vcdExtra/articles/creating.html) gives some examples.

A tidy CDA project might propose, test and implement some extensions to
the [vcdExtra package](https://github.com/friendly/vcdExtra), designed to reduce these problems.

More generally, a project to work on developing the [vcdExtra package](https://github.com/friendly/vcdExtra)
in other ways might be quite useful.  For example, you might extend the vignettes,
develop a scheme to classify the many datasets according to the types of methods (ordered factors, square tables, ...)
the illustrate, and so forth.


## Interactive apps

Years ago I developed an [interactive application for mosaic displays](http://euclid.psych.yorku.ca/cgi/mosaics),
using perl CGI programming to run a SAS program on my server. It was nice in that it offered
a number of sample datasets, some explanation of how it was done, and allowed upload of your
own data.

The framework still exists, but
SAS on the server has been retired.  It would be nice to develop a new application using, e.g., 
R Shiny, https://shiny.rstudio.com/. Or, anything else -- Python, D3.js, ...

For a collection of apps, see [Book Of Apps for Statistics Teaching](https://sites.psu.edu/shinyapps/).
There are a couple of simple ones for [categorical data](https://sites.psu.edu/shinyapps/category/upper-division-apps/categorical-data/).


## New areas for CDA

There is a wide range of other areas in which categorical data arises, but are not treated
directly in this course. Choose one or more and write a paper describing and illustrating them.

### Latent class analysis
LCA is a statistical method for finding subtypes of related cases ("latent classes") from
multivariate categorical data. It is often approached using Mplus, or other specific programs
(Latent Gold). A web page by Maksim Rudnov, [Ways to do Latent Class Analysis in R](https://maksimrudnev.com/2016/12/28/latent-class-analysis-in-r/)
describes some R packages for this.

### Confusion matrices 
These arise in a variety of contexts, similar to the idea of agreement in square tables,
but often with the idea of a predicted vs. actual classification. A paper by Kevin Johnson
[Visual Presentation of Statistical Concepts in Diagnostic Testing: The 2 x 2 Diagram](../papers/2x2_paper_2014.pdf) sketches some ideas for
2 x 2 tables. Another paper by David Lovell et al. [Taking the Confusion Out of Multinomial Confusion Matrices and Imbalanced Classes](../papers/Lovell-2021-Confusion.pdf)
considers larger tables, where the interest is on the 2 x 2 tables for each A, B pair of categories.

## Graphical models
These are an approach to multivariate data where variables are represented as nodes in a
network and systems of _conditional independence_ which can be described by undirected graphs.
[Course lecture slides by Steffen Lauritzen](https://www.stats.ox.ac.uk/~steffen/teaching/fsmHT07/fsm07.pdf) describe the basic ideas.

~~A too mathy book on this topic:
Roberato (2017) [Graphical Models for Categorical Data](https://www.cambridge.org/core/elements/abs/graphical-models-for-categorical-data/F9D4523D3559BC2BA9251CEF3077F20D)~~

Develop this idea in some ways to make a contribution to the **practice** of categorical data
analysis. This might use the `igraph` and `ggraph` packages to draw network diagrams, combined
with model fitting functions. A sketch of one beginning is given in [dayton-assoc-graph.R](dayton-assoc-graph.R);
output in [dayton-assoc-graph.html](dayton-assoc-graph.html)

## A consulting problem

Sean Rehag is director of the Center for Refugee Studies at Osgood Hall. He is currently
investigating decision making in the Federal Courts for "stays of removal," where a refugee
claimant can granted suspension of a removal order or put on a plane to their country of origin.

He has an extensive data base (4400 cases), classified by year, type of case, city, presiding judge, with
whether / not the stay request was granted.  An immediate goal is to help develop a plausible model
predicting the outcome.  There is a lot more meat in this project.

I will make the data and other documents available on request.

## Sequential analysis

In clinical psychology, there is a large literature on methods for analyzing relations of dyads ([therapist, client],
[husband, wife], [parent, child]) over time. Typically, behavioural interactions are recorded, and then
coded by trained observers into some set of categories to
identify patterns of behaviors and examine contingencies among data collected over time 
([Bakeman & Gottman, 1997](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2955832/#B4)).

Most often, such data are analyzed using simple measures of association (odds ratio, chisq) but with
a moving window over time or session.  For a project review some of the literature on this topic and
try to propose some alternatives, either in analysis or visualization.


