# Latent Class Analysis examples

Here are a few examples of LCA I've found using R. One take on this is that LCA is similar to CDA for a polytomous outcome,
but where membership in the response categories latent (unobserved), rather than manifest. Thus, a possible project
would be to explain the basics of LCA, illustrate with an example or two, and perhaps compare it with multinomial models.


- A main package for LCA is poLCA, https://CRAN.R-project.org/package=poLCA 
	The package includes several datasets, with examples.
	There is a JSS paper, https://www.jstatsoft.org/article/view/v042i10

- https://rpubs.com/eogawac/poLCA
	Uses data on 6 questions from American National Election Study of 2000
	to model afinity of voters with candidates Bush, Gore, Other
	This seems to be the same as poLCA::election

- https://pop.princeton.edu/events/2020/latent-class-analysis-using-r
	Contains a presentation, R script and dataset on mental health services facilities

- https://cran.r-project.org/web/packages/sBIC/vignettes/LatentClassAnalysis.pdf
	A vignette from the sBIC package
