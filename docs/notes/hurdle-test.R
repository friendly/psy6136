# testing hurdle methods


library(pscl)
data("bioChemists", package = "pscl")
fm_hp1 <- hurdle(art ~ ., data = bioChemists,
                 , dist = "negbin", zero = "negbin")
coef(fm_hp1)

names(fm_hp1)

class(fm_hp1)
# [1] "hurdle"

methods(class = "hurdle")
# [1] coef         extractAIC   fitted       logLik       model.matrix predict      predprob    
# [8] print        residuals    summary      terms        vcov  


hurdle_coefs <- function(coefs) {
  nms <- names(coefs)
  count_idx <- startsWith(nms, "count_")
  zero_idx  <- startsWith(nms, "zero_")

  count_coefs <- coefs[count_idx]
  zero_coefs  <- coefs[zero_idx]

  count_vars <- sub("^count_", "", names(count_coefs))
  zero_vars  <- sub("^zero_",  "", names(zero_coefs))

  all_vars <- union(count_vars, zero_vars)

  data.frame(
    term        = all_vars,
    count       = count_coefs[match(all_vars, count_vars)],
    zero        = zero_coefs[match(all_vars, zero_vars)],
    row.names   = NULL
  )
}

hurdle_coefs(coef(fm_hp1))

#
fm <- hurdle(art ~ ., data = bioChemists, dist = "negbin", zero = "negbin")
hurdletest(fm)

