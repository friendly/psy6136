# 6136 Individual or Team Projects

Here is a sketch of a couple of ideas that could be used for course evaluation
replacing some of the components I had planned. You can work on one of these
individually or with a partner. I would expect something more substantial for
a team project than an individual one. 

## Cat Data Research Bib

Compile a list of recent research papers illustrating intereating applications, 
modelling developments, graphical methods, ... of categorical data analysis.

Each should have a bibliographical citation, brief description, why it is
interesting or novel. Perhaps with subject / content / method tags or
catrgories.

I'm thinking of something like a shared google doc or something similar

## Tidy CDA? 

Categorical data simple for some purposes, but notoriously "untidy" --
table(), matrix(), array(), xtabs(), ... and many functions for analysis
or graphics accept data in a limited varieties of forms.  

A tidy CDA project might propose, test and implement some extensions to
the [vcdExtra package](https://github.com/friendly/vcdExtra), designed to reduce these problems.

## Interactive apps

Years ago I developed an [interactive application for mosaic displays](http://euclid.psych.yorku.ca/cgi/mosaics),
using perl CGI programming to run a SAS program on my server.  The framework still exists, but
SAS on the server has been retired.  It would be nice to develop a new application using, e.g., 
R Shiny, https://shiny.rstudio.com/.

For a collection of apps, see [Book Of Apps for Statistics Teaching](https://sites.psu.edu/shinyapps/).
There are a coup-le of simple ones for [categorical data](https://sites.psu.edu/shinyapps/category/upper-division-apps/categorical-data/)/.


## New areas for CDA

There is a wide range of other areas in which categorical data arises, but are not treated
directly in this course. Choose one or more and write a paper describing and illustrating them.

* **Latent class analysis** is a statistical method for finding subtypes of related cases ("latent classes") from
multivariate categorical data. It is often approached using Mplus, or other specific programs
(Latent Gold). A web page by Maksim Rudnov, [Ways to do Latent Class Analysis in R](https://maksimrudnev.com/2016/12/28/latent-class-analysis-in-r/)
describes some R packages for this.

* **Confusion matrices** arise in a variety of contexts, similar to the idea of agreement in square tables,
but often with the idea of a predicted vs. actual classification. A paper by Kevin Johnson
[Visual Presentation of Statistical Concepts in Diagnostic Testing: The 2 × 2 Diagram](papers/2x2_paper_2014.pdf) sketches some ideas for
2 x 2 tables. Another paper by David Lovell et al. [Taking the Confusion Out of Multinomial Confusion Matrices and Imbalanced Classes](papers/Lovell-2021-Confusion.pdf)
considers larger tables, where the interest is on the 2 x 2 tables for each A, B pair of categories.

* **Graphical models** are an approach to multivariate data where variables are represented as nodes in a
network and systems of _conditional independence_ which can be described by undirected graphs. 

## A consulting problem

Sean Rehag is director of the Center for Refugee Studies at Osgood Hall. He is currently
investigating decision making in the Federal Courts for "stays of removal," where a refugee
claimant can granted suspension of a removal order or put on a plane to their country of origin.

He has an extensive data base (4400 cases), classified by year, type of case, city, presiding judge, with
whether / not the stay request was granted.  An immediate goal is to help develop a plausible model
predicting the outcome.  There is a lot more meat in this project.

I will make the data and other documents available on request.

