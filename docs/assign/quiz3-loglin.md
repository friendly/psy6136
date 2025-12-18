# Quiz 3: Loglinear models


Test your knowledge of the material on [loglinear models](../lectures/04-Loglin.pdf) in the following quiz.

1. **What is a loglinear model for frequency tables in categorical data analysis?**
  a. A linear regression model for categorical data
  b. A logistic regression model for categorical data
  c. A statistical model for analyzing the relationship between categorical variables
  d. A model for predicting binary outcomes from categorical predictors

2. **How do you test for goodness of fit of a loglinear model for a two-way frequency table?**
  a. By using a chi-squared test
  b. By using a likelihood ratio test
  c. By using a Cochran-Mantel-Haenszel test
  d. By using Cohen's kappa.
  

3. **What is the main difference between a `glm()` loglinear model and the chi-squared test for independence in two-way frequency tables?**
  a. `glm()` models allow for different types of associations among variables while chi-squared test only tests for independence
  b. `glm()` models allow for non-normal data while chi-squared test do not
  c. `glm()` models apply in small sample size while chi-squared test require large sample size
  d. `glm()` models allow for estimation of parameters for interactions among variables and also for non-normal data while chi-squared test only tests for independence

4. **How does a loglinear model differ from a logit model?**
a. Loglinear models are linear while logit models are non-linear
b. Logit models handle only binary outcomes while loglinear models handle more than 2 outcomes
c. Loglinear models are used for continuous data while logit models are used for categorical data
d. Logit models estimate probabilities while loglinear models estimate frequencies

5. **What is the difference between a loglinear model fit by `loglm()` and one fit using `glm()`?**
a. `loglm()` requires large samples while `glm()` can be used for smaller samples
b. `loglm()` only estimates fitted values while `glm()` estimates parameters
c. `loglm()` uses an interative process while `glm()` provides an exact solution
d. `loglm()` gives the Pearson chi-square test while `glm()` gives the likelihood ratio test

6. **What are the advantages of a loglinear model fit using `glm()` over one fit using `loglm()`**
a. `glm()` estimates parameters while `loglm()` estimates only fitted values
b. `glm()` can handle ordinal and quantitative predictors while `loglm()` cannot
c. `glm()` can accommodate over-dispersion while `loglm()` cannot
d. All of the above

7. **How can you extend a loglinear model for frequency tables to handle multi-way contingency tables?**
a. By adding association terms to the model
b. By fitting separate loglinear models for each combination of predictors
c. By using a multivariate linear regression model
d. By using a multinomial logistic regression model

8. **For a three-way frequency table what is the interpretation of the model symbolized by `[A B] [A C]`**
a. A and B are conditionally independent given C
b. B and C are conditionally independent given A
c. A and B are mutually independent 
d. The association between A and B is the same for all levels of C
