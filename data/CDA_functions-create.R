# Read & save the table of functions for the R-functions document
# 
library(readr)
CDA_functions <- read_csv("data/CDA_functions.csv")

save(CDA_functions, file = "data/CDA_functions.RData")