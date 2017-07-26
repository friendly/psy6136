# script to install needed lab packages for R Windows

#  1. Open Rgui on the local drive or image server (e.g.,  drive:\R\R-3.1.1\bin\Rgui.exe)
#  2. Run the following script
#     - Select any convenient CRAN mirror from the pop-up list

#  All packages should be installed into the library directory of the current R version
#  (e.g., drive:\R\R-3.1.1\library)

# main packages for the VCD short course
vcdpkgs <-c("vcdExtra", "ca", "car", "catspec", "coin", "corrgram", "effects", 
            "gmodels", "gnm", "reshape", "vcd")

# other useful packages
otherpkgs <-c("ade4", "candisc", "ggplot2", "heplots", "HH", "rms", "latticeExtra", 
"lme4", "plyr", "Rcmdr", "RcmdrPlugin.HH", "reshape", "rgl", "sem", "TeachingDemos")

allpkgs <- union(vcdpkgs, otherpkgs)

# install the above, along with any dependencies
install.packages(allpkgs, dependencies=TRUE)
# update any recently modified packages
update.packages(ask='graphics')

