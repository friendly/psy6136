# script to install needed lab packages for R Windows

#  1. Open Rgui on the local drive or image server (e.g.,  drive:\R\R-3.4.1\bin\Rgui.exe)

#  2a. Run the following script (e.g., copy/paste contents of this file to the R console)

#  2b. Alternatively, just run the following line in the R console:
#  source("http://euclid.psych.yorku.ca/www/psy6136/R/install-vcd-pkgs.R")
#   

# main packages for the VCD short course
vcdpkgs <-c("vcd", "vcdExtra", "ca", "car", "catspec", "coin", "corrgram", "effects", 
            "gmodels", "gnm", "reshape")

# other useful packages
otherpkgs <-c("ade4", "candisc", "ggplot2", "heplots", "HH", "rms", "latticeExtra", 
              "lme4", "dplyr", "reshape", "rgl", "sem", "TeachingDemos",
              "tidyverse", "knitr", "psych", "lavaan" )

allpkgs <- union(vcdpkgs, otherpkgs)

# install the above, along with any dependencies
install.packages(allpkgs, dependencies=TRUE)

# update any recently modified packages
update.packages(ask='graphics')

