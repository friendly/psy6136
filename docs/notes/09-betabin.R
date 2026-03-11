# ============================================================
# Figures for beta-binomial slides (09-CountData.pptx)
# notes/09-betabin.R
# ============================================================

library(ggplot2)
library(dplyr)
library(tidyr)

# ------------------------------------------------------------
# Figure 1 (Slide 2): Beta density curves
# Varying φ (concentration) with fixed μ = 0.3
# Shows how π collapses toward μ as φ grows
# ------------------------------------------------------------

# Beta(α, β) parameterized by mean μ and concentration φ:
#   α = μ * φ,  β = (1 - μ) * φ

mu_val  <- 0.3
phi_vals <- c(2, 5, 20, 100)

beta_df <- expand.grid(
  pi  = seq(0.001, 0.999, length.out = 500),
  phi = phi_vals
) |>
  mutate(
    alpha   = mu_val * phi,
    beta_p  = (1 - mu_val) * phi,
    density = dbeta(pi, alpha, beta_p),
    phi_lab = factor(paste0("φ = ", phi), levels = paste0("φ = ", phi_vals))
  )

# Direct curve labels: above each peak (φ=2 is J-shaped so fix its x manually)
label_df <- beta_df |>
  group_by(phi, phi_lab) |>
  slice_max(density, n = 1, with_ties = FALSE) |>
  ungroup() |>
  mutate(
    pi      = ifelse(phi == 2, 0.04, pi),           # move J-shape label off the boundary
    density = dbeta(pi, mu_val * phi, (1 - mu_val) * phi),
    label_y = density + 0.5                          # nudge above the curve
  )

# Sequential blue palette: light (spread) → dark (concentrated)
phi_colors <- c("φ = 2"   = "#9ecae1",
                "φ = 5"   = "#4292c6",
                "φ = 20"  = "#2171b5",
                "φ = 100" = "#084594")

fig1 <- ggplot(beta_df, aes(x = pi, y = density, color = phi_lab)) +
  geom_line(linewidth = 1.2) +
  geom_text(data = label_df,
            aes(x = pi, y = label_y, label = phi_lab, color = phi_lab),
            size = 5.5, hjust = 0.5, fontface = "bold", show.legend = FALSE) +
  geom_vline(xintercept = mu_val, linetype = "dashed", color = "grey40") +
  annotate("text", x = mu_val + 0.02, y = Inf,
           label = paste0("μ = ", mu_val), vjust = 1.4,
           color = "grey40", size = 5) +
  scale_color_manual(values = phi_colors, guide = "none") +
  scale_x_continuous(breaks = seq(0, 1, by = 0.2)) +
  coord_cartesian(ylim = c(0, 10)) +
  labs(
    title    = "Beta distribution: varying concentration φ",
    subtitle = paste0("μ = ", mu_val, " fixed;  α = μφ,  β = (1−μ)φ", " -> φ = c(2, 5, 20, 100)"),
    x        = "π  (probability)",
    y        = "Density"
  ) +
  theme_bw(base_size = 14)

fig1

# ------------------------------------------------------------
# Figure 1b (Slide 2, optional): grid over μ AND φ
# Shows the full flexibility of the Beta distribution
# ------------------------------------------------------------

mu_vals2  <- c(0.2, 0.5, 0.8)
phi_vals2 <- c(2, 10, 50)

beta_df2 <- expand.grid(
  pi  = seq(0.001, 0.999, length.out = 400),
  mu  = mu_vals2,
  phi = phi_vals2
) |>
  mutate(
    alpha   = mu * phi,
    beta_p  = (1 - mu) * phi,
    density = dbeta(pi, alpha, beta_p),
    mu_lab  = factor(paste0("μ = ", mu),  levels = paste0("μ = ",  mu_vals2)),
    phi_lab = factor(paste0("φ = ", phi), levels = paste0("φ = ", phi_vals2))
  )

fig1b <- ggplot(beta_df2, aes(x = pi, y = density)) +
  geom_line(linewidth = 0.8, color = "steelblue") +
  geom_vline(aes(xintercept = mu), linetype = "dashed", color = "grey50") +
  facet_grid(phi_lab ~ mu_lab, scales = "free_y") +
  scale_x_continuous(breaks = c(0, 0.5, 1)) +
  labs(
    title    = "Beta distribution: varying μ (columns) and φ (rows)",
    subtitle = "Dashed line = mean μ; larger φ → more concentrated",
    x        = "π  (probability)",
    y        = "Density"
  ) +
  theme_bw(base_size = 12) +
  theme(strip.background = element_rect(fill = "grey90"))

fig1b

# ------------------------------------------------------------
# Figure 2 (Slide 3): Overdispersion — observed vs. expected
# Simulate binomial and beta-binomial data, compare variance
# ------------------------------------------------------------

set.seed(42)
n_obs  <- 500   # number of observations
n_size <- 20    # number of trials per observation
mu_sim <- 0.4   # true mean probability

# --- Binomial (no overdispersion) ---
y_binom <- rbinom(n_obs, size = n_size, prob = mu_sim)

# --- Beta-Binomial (overdispersed): φ = 5 ---
phi_sim <- 5
alpha_sim <- mu_sim * phi_sim
beta_sim  <- (1 - mu_sim) * phi_sim

pi_i    <- rbeta(n_obs, alpha_sim, beta_sim)   # individual probabilities
y_bbin  <- rbinom(n_obs, size = n_size, prob = pi_i)

# Theoretical variances
var_binom <- n_size * mu_sim * (1 - mu_sim)
var_bbin  <- var_binom * (1 + (n_size - 1) / (phi_sim + 1))

sim_df <- data.frame(
  y     = c(y_binom, y_bbin),
  model = rep(c(
    paste0("Binomial\nVar = ", round(var_binom, 2)),
    paste0("Beta-Binomial  (φ = ", phi_sim, ")\nVar = ", round(var_bbin, 2))
  ), each = n_obs)
)

fig2 <- ggplot(sim_df, aes(x = y)) +
  geom_bar(aes(y = after_stat(prop)), fill = "steelblue", color = "white",
           width = 0.8) +
  geom_vline(xintercept = mu_sim * n_size, linetype = "dashed",
             color = "firebrick", linewidth = 0.8) +
  facet_wrap(~model) +
  scale_x_continuous(breaks = seq(0, n_size, by = 4)) +
  labs(
    title    = "Binomial vs. Beta-Binomial: effect of overdispersion",
    subtitle = paste0("n = ", n_size, " trials, μ = ", mu_sim,
                      ";  dashed line = expected mean"),
    x        = paste0("Y  (successes out of ", n_size, ")"),
    y        = "Proportion"
  ) +
  theme_bw(base_size = 13) +
  theme(strip.background = element_rect(fill = "grey90"),
        strip.text = element_text(size = 11))

fig2
