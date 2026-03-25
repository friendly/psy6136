library(vcdExtra)
library(MultBiplotR)
library(dplyr)
library(tidyr)

# Load and aggregate data
data(Mice, package = "vcdExtra")
mice.tab <- xtabs(Freq ~ litter + treatment + deaths, data=Mice)

# Convert to data frame and create logits
# Adding a small constant (0.5) to avoid log(0) issues
mice_df <- as.data.frame(mice.tab) |>
  pivot_wider(names_from = deaths, values_from = Freq) |>
  mutate(
    logit_0_1 = log((`0` + 0.5) / (`1` + 0.5)),
    logit_1_2 = log((`1` + 0.5) / (`2+` + 0.5))
  )

# Create the matrix for Biplot (Rows = Litter:Treatment, Cols = Logits)
row_names <- paste(mice_df$litter, mice_df$treatment, sep=":")
biplot_mat <- as.matrix(mice_df[, c("logit_0_1", "logit_1_2")])
rownames(biplot_mat) <- row_names

# Perform PCA on the log-odds matrix
# This uses SVD internally to decompose the log-odds associations
bip_mice <- PCA.Biplot(biplot_mat)
bip_mice

# Plot the 2D Biplot
plot(bip_mice, 
     Title = "Log Odds Ratio Biplot: Mice Data",
     CexInd = 1.2, 
     ColorInd = c("blue", "darkgreen")[as.numeric(mice_df$treatment)], # Color points by treatment
     CexVar = 1.4,
     ColorVar = "darkred",
     PchInd = 16,
     xpd = TRUE,
     cex.lab = 1.3)
abline(h = 0, v = 0, col = "gray")


