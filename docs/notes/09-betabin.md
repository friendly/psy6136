# Beta-Binomial Regression: Slide Sketches
## To insert after slide 85 in `lectures/09-CountData.pptx`

Display equations are in LaTeX (paste into PPT via Insert → Equation → LaTeX mode).
Inline math uses Unicode symbols for direct paste into bullet text.

---

## Slide 1 — "Overdispersion in proportions and counts"

**Title:** Overdispersion in proportions and counts

**Body:**

So far: count data, Y ~ Poisson(μ) — handled overdispersion with NegBin

Now: **proportion** or **binomial** data
- Y = number of "successes" out of n trials: Y ~ Binomial(n, π)
- Logistic / binomial regression assumes Var(Y) = nπ(1−π)
- But real data often show **more** variation than this

**When does overdispersion arise here?**
- π varies across individuals beyond what predictors explain
- Clustering: observations within groups are more similar than between groups
- Unobserved heterogeneity in the "true" probability

**Diagnosing overdispersion:**
- Residual deviance ≫ residual df in `glm(..., family=binomial)`
- Pearson χ²/df ≫ 1
- Overdispersion parameter φ̂ = χ²_P / (N − p) > 1

```r
m.bin <- glm(cbind(y, n - y) ~ x1 + x2, data = dat, family = binomial)
summary(m.bin)   # check: residual deviance / df
```

**Quick fix:** `family = quasibinomial` — inflates SEs, but doesn't model the heterogeneity

---

## Slide 2 — "Mixing probabilities: The Beta distribution"

**Title:** Mixing probabilities: The Beta distribution

**Body:**

The core idea: instead of a single fixed π, let π itself vary across observations

**[EQUATION]**
```latex
\pi \sim \text{Beta}(\alpha, \beta), \quad \alpha > 0,\ \beta > 0
```

**Properties of Beta(α, β):**
- Support: π ∈ (0, 1) — natural for probabilities
- E(π) = μ = α / (α + β)
- Var(π) = μ(1−μ) / (α + β + 1)

**Re-parameterize** with mean μ and concentration φ = α + β:
- α = μφ,  β = (1−μ)φ

- Large φ: π tightly concentrated around μ (less heterogeneity)
- Small φ: π spread widely over (0, 1) (more heterogeneity)

[**Figure idea:** Beta density curves for several (μ, φ) combinations, e.g., μ = 0.3 with φ = 2, 5, 20, 100, showing the distribution collapsing toward μ as φ grows]

---

## Slide 3 — "Beta-Binomial: Binomial with a random probability"

**Title:** Beta-Binomial: Binomial with a random probability

**Body:**

**Hierarchical structure** (two-stage model):

**[EQUATIONS — paste each into its own equation box]**
```latex
\pi_i \sim \text{Beta}(\mu_i \phi,\ (1-\mu_i)\phi)
```
```latex
Y_i \mid \pi_i \sim \text{Binomial}(n_i,\ \pi_i)
```

**Marginal mean and variance** (after integrating out π_i):
- E(Y_i) = n_i μ_i  ← same as binomial

```latex
\text{Var}(Y_i) = n_i \mu_i(1-\mu_i)\left[1 + (n_i - 1)\frac{1}{\phi+1}\right]
```

- The bracketed term is the **overdispersion factor** > 1 (when n_i > 1)
- When φ → ∞: variance → nμ(1−μ), reduces to standard Binomial
- ρ = 1/(φ+1) is the **intraclass correlation** (ICC)

**Link function:** same logistic link as before

```latex
\log\!\left(\frac{\mu_i}{1-\mu_i}\right) = \mathbf{x}_i^\top \boldsymbol{\beta}
```

---

## Slide 4 — "Fitting Beta-Binomial models in R"

**Title:** Fitting Beta-Binomial models in R

**Body:**

Several packages support beta-binomial regression:

```r
# Option 1: aod package
library(aod)
m.bb <- betabin(cbind(y, n - y) ~ x1 + x2, ~ 1, data = dat)
summary(m.bb)

# Option 2: VGAM package
library(VGAM)
m.bb2 <- vglm(cbind(y, n - y) ~ x1 + x2,
              family = betabinomial, data = dat)
summary(m.bb2)

# Option 3: glmmTMB — for mixed models too
library(glmmTMB)
m.bb3 <- glmmTMB(y/n ~ x1 + x2, weights = n,
                 family = betabinomial, data = dat)
```

**Interpretation:**
- β̂: log-odds coefficients — same as logistic regression
- φ̂ (or ρ̂): estimated concentration / ICC
- H₀: φ → ∞ (i.e., ρ = 0) — test with LRT vs. binomial

**Model comparison:**
```r
# Is overdispersion significant?
anova(m.bin, m.bb, test = "LRT")
AIC(m.bin); AIC(m.bb)
```

**Note on extensions:**
- φ can itself be modeled as a function of predictors (heterogeneous overdispersion)
- Beta-binomial is the binomial analog of the **negative binomial** for counts

---

## Notes / To-do for slides

- **Example dataset:** Consider using `aod::orob2` (germination data: seeds on different root extracts)
  or a psychology example with proportion-correct responses across participants.

- **Figure for slide 2:** `ggplot` of Beta densities (use `geom_function` + `dbeta`)

- **Figure for slide 3:** Simulated data showing observed variance vs. binomial-predicted variance;
  or a rootogram for the beta-binomial fit.

- **Connection to lecture flow:** After slide 85 ("What else is there?"), introduce as:
  "What about *proportions*? The same overdispersion problem arises — here's the solution."

- **Parallel structure to NegBin story:**

  | Count data | Proportion / Binomial data |
  |---|---|
  | Poisson: Var = μ | Binomial: Var = nπ(1−π) |
  | Overdispersion: Var > μ | Overdispersion: Var > nπ(1−π) |
  | Quasi-Poisson (ad hoc) | Quasi-Binomial (ad hoc) |
  | Negative Binomial (Poisson-Gamma mixture) | **Beta-Binomial** (Binomial-Beta mixture) |
