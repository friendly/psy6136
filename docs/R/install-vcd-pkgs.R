# script to install needed lab packages for R Windows

#  Open this script in an RStudio editor window and press Run

#  Alternatively, just run the following line in the R console:
#  source("https://friendly.github.io/psy6136/psy6136/R/install-vcd-pkgs.R")
#   

# main packages for the VCD short course
vcdpkgs <-c("vcd", "vcdExtra", "ca", "car", "catspec", "coin", "corrgram", "effects", 
            "gmodels", "gnm", "reshape", "catdata", "pscl")

# other useful packages
otherpkgs <-c("ade4", "candisc", "ggplot2", "heplots", "HH", "rms", "latticeExtra", 
              "lme4", "dplyr", "reshape", "rgl", "rmarkdown", "sem", "TeachingDemos",
              "tidyverse", "knitr", "psych", "lavaan" )

allpkgs <- union(vcdpkgs, otherpkgs)

# install the above, along with any dependencies
install.packages(allpkgs, dependencies=TRUE)

# update any recently modified packages
update.packages(ask='graphics')

