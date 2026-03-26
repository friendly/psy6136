# SVD & Biplots for Log Odds Ratios: Slide Sketches
## To insert after slide 33 in `lectures/10-Log-Odds.pptx`

Display equations are in LaTeX (paste into PPT via Insert → Equation → LaTeX mode).
Inline math uses Unicode symbols for direct paste into bullet text.

---

## Slide 1 — "Another way to visualize: Biplots of log odds"

**Title:** Another way to visualize: Biplots of log odds

**Body:**

Previous plots: separate panels for each factor combination — hard to see the joint structure

**A different question:** Can we display rows (litter × treatment) and columns (log-odds contrasts) together in one plot?

**Key idea:**
- Arrange the log odds as a matrix **L** with rows = observational units, columns = response contrasts
- Apply the **SVD** to **L** to find a low-dimensional approximation
- Display the result as a **biplot**: rows as points, columns as arrows

**Why biplots?**
- Compress a multi-dimensional log-odds structure into 2D
- Rows that are similar in their log-odds profiles cluster together
- Column arrows show which contrasts vary most and how they co-vary
- Treatment and litter effects can be seen simultaneously

---

## Slide 2 — "Setting up the log-odds matrix"

**Title:** Setting up the log-odds matrix

**Body:**

For the Mice data (litter × treatment × deaths):

- Rows: 10 combinations of litter (7–11) × treatment (A, B)
- Columns: 2 log-odds contrasts among deaths

**[EQUATION]**
```latex
\mathbf{L} = \begin{pmatrix}
\ell_{7A,\,0:1}   & \ell_{7A,\,1:2+} \\
\ell_{8A,\,0:1}   & \ell_{8A,\,1:2+} \\
\vdots & \vdots \\
\ell_{11B,\,0:1}  & \ell_{11B,\,1:2+}
\end{pmatrix}
\quad (10 \times 2)
```

Each entry is:
```latex
\ell_{ij} = \log\!\left(\frac{n_{ij} + 0.5}{n_{i,j+1} + 0.5}\right)
```

(+0.5 added to avoid log(0) for sparse cells)

**In R:**
```r
mice_df <- as.data.frame(mice.tab) |>
  pivot_wider(names_from = deaths, values_from = Freq) |>
  mutate(
    logit_0_1 = log((`0` + 0.5) / (`1`  + 0.5)),
    logit_1_2 = log((`1` + 0.5) / (`2+` + 0.5))
  )

biplot_mat <- as.matrix(mice_df[, c("logit_0_1", "logit_1_2")])
rownames(biplot_mat) <- paste(mice_df$litter, mice_df$treatment, sep = ":")
```

---

## Slide 3 — "SVD and the biplot approximation"

**Title:** SVD and the biplot approximation

**Body:**

**Singular Value Decomposition** of the (centered) log-odds matrix **L**:

**[EQUATION]**
```latex
\mathbf{L} = \mathbf{U}\,\mathbf{D}\,\mathbf{V}^\top
```

- **U** ($n \times r$): left singular vectors — row scores (one per litter:treatment combination)
- **D** ($r \times r$): diagonal matrix of singular values $d_1 \geq d_2 \geq \cdots$
- **V** ($p \times r$): right singular vectors — column scores (one per log-odds contrast)

**Biplot approximation** using the first two dimensions:

```latex
\mathbf{L} \approx \mathbf{F}\,\mathbf{G}^\top, \quad
\mathbf{F} = \mathbf{U}_2\,\mathbf{D}_2^{\alpha}, \quad
\mathbf{G} = \mathbf{V}_2\,\mathbf{D}_2^{1-\alpha}
```

- **F**: row (observation) coordinates — plotted as **points**
- **G**: column (variable) coordinates — plotted as **arrows** from the origin
- $\alpha = 1$: row-metric-preserving ("form") biplot — distances among rows are accurate
- $\alpha = 0$: column-metric-preserving ("covariance") biplot — inner products reflect covariances

**Proportion of variance explained** by dimension $k$:

```latex
r_k = \frac{d_k^2}{\sum_j d_j^2}
```

---

## Slide 4 — "Biplot interpretation"

**Title:** Biplot interpretation

**Body:**

**Reading a biplot:**

| Feature | Interpretation |
|---|---|
| Points close together | Similar log-odds profiles across all contrasts |
| Points far apart | Very different log-odds profiles |
| Long arrow | That contrast varies a lot across rows |
| Short arrow | That contrast is nearly constant (little info) |
| Angle between arrows ≈ 0° | High positive correlation between contrasts |
| Angle between arrows ≈ 180° | High negative correlation |
| Angle between arrows ≈ 90° | Contrasts are uncorrelated |

**Projecting a point onto an arrow:**
- The (signed) length of the projection of row $i$ onto column $j$'s arrow approximates $\ell_{ij}$ (relative to the mean)
- Rows that project far in the direction of an arrow → high log odds on that contrast

**In the Mice data:**
- Do treatment A and B separate along one dimension?
- Does litter size drive log odds along a gradient?
- Are the two death contrasts (0:1 and 1:2+) correlated across litter × treatment?

---

## Slide 5 — "Biplot of Mice log odds: Code"

**Title:** Biplot of Mice log odds: Code

**Body:**

Using `MultBiplotR::PCA.Biplot()`, which applies PCA (SVD of the centered matrix) and provides a biplot plot method:

```r
library(MultBiplotR)

bip_mice <- PCA.Biplot(biplot_mat)
bip_mice   # prints variance explained by each PC

plot(bip_mice,
     Title    = "Log Odds Ratio Biplot: Mice Data",
     CexInd   = 1.2,
     ColorInd = c("blue", "darkgreen")[as.numeric(mice_df$treatment)],
     CexVar   = 1.4,
     ColorVar = "darkred",
     PchInd   = 16,
     xpd      = TRUE,
     cex.lab  = 1.3)
abline(h = 0, v = 0, col = "gray")
```

**Notes:**
- `ColorInd`: colors points by treatment (blue = A, green = B)
- `PchInd = 16`: filled circles for the row points
- Column arrows (`ColorVar = "darkred"`) represent the two log-odds contrasts
- `abline(h=0, v=0)`: reference axes through the biplot origin

---

## Slide 6 — "Biplot of Mice log odds: Interpretation"

**Title:** Biplot of Mice log odds: Interpretation

**Body:**

**[Figure: biplot output from `plot(bip_mice, ...)`]**

**What to look for:**

- **Treatment separation:** Blue (A) vs. green (B) points — do they cluster separately along one axis?
  - Separation ⟹ treatment has an effect on log-odds profiles distinct from litter size

- **Litter gradient:** Within each treatment, do points for litter 7 → 11 fall along a smooth gradient?
  - A gradient ⟹ litter size has a systematic effect on log odds (consistent with the linear model on slide 33)

- **Column arrows (log-odds contrasts):**
  - If the two arrows (0:1 and 1:2+) point in similar directions → the two contrasts are positively correlated across litter/treatment conditions
  - Arrow length ∝ variance of that contrast in the data

- **Unusual points:**
  - Recall the outlier visible in the model plot (slide 32) — does it stand apart in the biplot as well?

**Connection to earlier slides:**
- The biplot summarizes the same log-odds matrix **L** that we modeled with `lm()` (slides 31–33)
- The biplot is a *model-free* visualization; the linear model imposes structure
- Together they give a more complete picture of the data

---

## Notes / To-do for slides

- **Check variance explained:** report $r_1 + r_2$ on the axis labels or in a subtitle — if ≥ 90%, the 2D display is a faithful summary
- **Connection to PCA:** `PCA.Biplot()` mean-centers **L** before the SVD; this is equivalent to working with deviations from average log odds
- **Alternative packages:**
  - `FactoMineR::PCA()` + `factoextra::fviz_pca_biplot()` for a ggplot-style biplot
  - `vcd::loddsratio()` + base `biplot()` for a quick biplot directly from the log-odds object
- **Figure for slides 5–6:** run `R/mice-biplot.R` and export the plot (PDF or PNG)
- **Placement in lecture:** insert between slide 33 ("Visualize log odds & models: Data + Model") and current slide 34 ("Generalized log odds ratios") — this section provides a complementary graphical view before moving to the more general theory
