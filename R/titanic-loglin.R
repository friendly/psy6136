#' ---
#' title: "Survival on the titanic, using loglm()"
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

#' ## Exercises: survival on the titanic, using loglm()

library(MASS)     # for loglm()
library(vcd)      # for mosaic, aka plot.loglm()

data(Titanic, package="datasets")  # effects::Titanic gives a case-form version

#' ## Baseline model 
Titanic <- Titanic + 0.5   # adjust for 0 cells
titanic.mod1 <- loglm(~ (Class * Age * Sex) + Survived, data=Titanic)
titanic.mod1
plot(titanic.mod1, main="Model [AGC][S]")

#' ## Associations with survival 
titanic.mod2 <- loglm(~ (Class * Age * Sex) + Survived*(Class + Age + Sex), data=Titanic)
titanic.mod2
plot(titanic.mod2,  main="Model [AGC][AS][GS][CS]")

#' ## update() is a simpler way:
update(titanic.mod1, . ~ .+ Survived*(Class+Age+Sex))

titanic.mod3 <- loglm(~ (Class * Age * Sex) + Survived*(Class + Age * Sex), data=Titanic)
titanic.mod3
plot(titanic.mod3, main="Model [AGC][AS][GS][CS][AGS]")

#' ## compare models
anova(titanic.mod1, titanic.mod2, titanic.mod3, test="chisq")


