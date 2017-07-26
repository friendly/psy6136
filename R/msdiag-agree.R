#' ---
#' title: "MSPatients: Agreement"
#' author: "Michael Friendly"
#' date: "21 Jan 2015"
#' ---

library(vcd)
data(MSPatients, package="vcd")

#' ## Calculate Kappa for each set of patients
Kappa(MSPatients[,,1])
Kappa(MSPatients[,,2])
confint(Kappa(MSPatients[,,1]))
confint(Kappa(MSPatients[,,2]))

#' ## Agreement plots
agreementplot(t(MSPatients[,,1]), main = "Winnipeg Patients")
agreementplot(t(MSPatients[,,2]), main = "New Orleans Patients")
