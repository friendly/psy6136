#' ---
#' title: "Two way tables tutorial"
#' date: "27 Sep 2017"
#' ---

data("Hospital", package="vcd")
Hospital

str(Hospital)
#' NB: the table names are peculiar (have spaces)
names(dimnames(Hospital))
#' You can change these, but, as is, they make the plots nicer
# names(dimnames(Hospital)) <- c("Visits", "Stay")

#' row proportions
prop.table(Hospital, 1)

#' ## tests of association
#' chisquare test
chisq.text(Hospital)

chisq.text(Hospital, simulate=TRUE)

MASS::loglm(~ 1+2, data=Hospital)

assocstats(Hospital)

#' ordinal tests
CMHtest(Hospital)

# get chisq / df

cc <- CMHtest(Hospital)
names(cc)

tab <- cc$table
tab[,1] / tab[,2]

#' ## Plots
plot(Hospital, shade=TRUE)

tile(Hospital, shade=TRUE)
tile(Hospital, tile_type="height", shade=TRUE)

spineplot(Hospital)