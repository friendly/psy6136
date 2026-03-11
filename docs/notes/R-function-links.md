# Adding Documentation Links to R-functions.Rmd

Notes on linking function names to their documentation on rdrr.io.

## URL Format for rdrr.io

The general URL pattern is:

```
https://rdrr.io/cran/{package}/man/{function}.html
```

Examples:
- `chisq.test()` → https://rdrr.io/r/stats/chisq.test.html (base R uses `/r/` not `/cran/`)
- `goodfit()` → https://rdrr.io/cran/vcd/man/goodfit.html
- `glm()` → https://rdrr.io/r/stats/glm.html
- `ca()` → https://rdrr.io/cran/ca/man/ca.html

### Base R packages use `/r/` prefix

Functions in base R packages (stats, graphics, grDevices, utils, methods, base) use:
```
https://rdrr.io/r/{package}/{function}.html
```

### CRAN packages use `/cran/` prefix

```
https://rdrr.io/cran/{package}/man/{function}.html
```

### GitHub packages use `/github/` prefix

```
https://rdrr.io/github/{user}/{repo}/man/{function}.html
```

Example for nestedLogit (but thai IS on CRAN)
```
https://rdrr.io/github/friendly/nestedLogit/man/nestedLogit.html
```

## Markdown Syntax for Tables

Current format:
```markdown
| Method | Function | Package | Description |
|--------|----------|---------|-------------|
| Goodness-of-fit test | `chisq.test()` | stats | Chi-square test |
```

With links:
```markdown
| Method | Function | Package | Description |
|--------|----------|---------|-------------|
| Goodness-of-fit test | [`chisq.test()`](https://rdrr.io/r/stats/chisq.test.html) | stats | Chi-square test |
```

## Implementation Approaches

### Option 1: Manual replacement

Tedious but straightforward. Search and replace each function.

### Option 2: R script to generate links

```r
# Function to generate rdrr.io URL
rdrr_url <- function(fun, pkg) {
  # Remove parentheses from function name
 fun_clean <- gsub("\\(\\)", "", fun)

 # Base R packages
 base_pkgs <- c("stats", "graphics", "grDevices", "utils",
                 "methods", "base", "datasets")

 if (pkg %in% base_pkgs) {
   sprintf("https://rdrr.io/r/%s/%s.html", pkg, fun_clean)
 } else {
   sprintf("https://rdrr.io/cran/%s/man/%s.html", pkg, fun_clean)
  }
}

# Example
rdrr_url("chisq.test", "stats")
# [1] "https://rdrr.io/r/stats/chisq.test.html"

rdrr_url("goodfit", "vcd")
# [1] "https://rdrr.io/cran/vcd/man/goodfit.html"
```

### Option 3: Use R Markdown inline code

In the Rmd file, could define a helper function in a setup chunk:

```r
```{r setup, echo=FALSE}
fn_link <- function(fun, pkg) {
  fun_clean <- gsub("\\(\\)", "", fun)
  base_pkgs <- c("stats", "graphics", "grDevices", "utils",
                 "methods", "base", "datasets")

  if (pkg %in% base_pkgs) {
    url <- sprintf("https://rdrr.io/r/%s/%s.html", pkg, fun_clean)
  } else {
    url <- sprintf("https://rdrr.io/cran/%s/man/%s.html", pkg, fun_clean)
  }
  sprintf("[`%s()`](%s)", fun_clean, url)
}
```

Then use inline R:
```markdown
| Method | Function | Package |
|--------|----------|---------|
| GOF test | `r fn_link("chisq.test", "stats")` | stats |
```

**Problem:** Inline R in table cells can be finicky with rendering.

### Option 4: Generate table from data frame

Create the table programmatically:

```r
```{r, results='asis', echo=FALSE}
library(knitr)

functions_df <- data.frame(
  Method = c("Goodness-of-fit test", "Goodness-of-fit test"),
  Function = c("chisq.test", "goodfit"),
  Package = c("stats", "vcd"),
  Description = c("Chi-square test", "Fit discrete distributions")
)

# Add links
functions_df$Function <- mapply(fn_link,
                                 functions_df$Function,
                                 functions_df$Package)

kable(functions_df)
```

## Potential Problems

### 1. Functions with dots in names

Some functions have dots that could cause URL issues:
- `chisq.test` → works fine
- `t.test` → works fine

The `.html` extension is added after, so dots in function names are OK.

### 2. Functions with same name in multiple packages

Examples:
- `select()` - dplyr, MASS
- `filter()` - dplyr, stats
- `summarize()` - dplyr, Hmisc

Solution: Always specify the correct package. The table already has a Package column.

### 3. S3 methods

Functions like `plot.ca()` are S3 methods. The documentation might be:
- Under the generic: `plot`
- Under the method: `plot.ca`
- In a combined help page

For `plot.ca` from the ca package:
- Try: https://rdrr.io/cran/ca/man/plot.ca.html

### 4. Replacement functions

Functions like `names<-` need URL encoding:
- `names<-` → `names%3C-.html` or might be documented with `names`

### 5. Infix operators

Functions like `%>%` need encoding:
- `%>%` → `%25%3E%25`

Better to link to the package documentation page instead.

### 6. Deprecated or moved functions

Some functions move between packages or get deprecated:
- Check that links work after generating
- Some older functions might redirect

### 7. GitHub-only packages

Packages not on CRAN need the GitHub URL format:
```
https://rdrr.io/github/friendly/nestedLogit/man/nestedLogit.html
```

### 8. Package name case sensitivity

CRAN package names in URLs are case-sensitive:
- `MASS` not `mass`
- `DescTools` not `desctools`

### 9. Bioconductor packages

Use `/bioc/` prefix:
```
https://rdrr.io/bioc/{package}/man/{function}.html
```

(Not currently relevant for this course but worth noting.)

## Testing Links

Before publishing, should verify links work. Could write a script:

```r
library(httr)

check_link <- function(url) {
  response <- HEAD(url)
  status_code(response) == 200
}

# Test a few
urls <- c(
 "https://rdrr.io/r/stats/chisq.test.html",
  "https://rdrr.io/cran/vcd/man/goodfit.html",
  "https://rdrr.io/cran/vcd/man/mosaic.html"
)

sapply(urls, check_link)
```

## Alternative Documentation Sites

If rdrr.io doesn't work for some functions:

1. **RDocumentation.org**
   ```
   https://www.rdocumentation.org/packages/{package}/versions/{version}/topics/{function}
   ```
   Con: Requires version number

2. **Package websites (pkgdown sites)**
   - vcd: https://friendly.github.io/vcd/reference/
   - vcdExtra: https://friendly.github.io/vcdExtra/reference/
   - ca: https://cran.r-project.org/web/packages/ca/ca.pdf (PDF only)

3. **Direct CRAN links**
   ```
   https://cran.r-project.org/web/packages/{package}/vignettes/
   ```

## Recommended Approach

1. Start with Option 4 (programmatic generation) for maintainability
2. Create a CSV or data frame with all functions, packages, descriptions
3. Use the helper function to generate links
4. Output with `kable()` or similar
5. Test all links before publishing
6. Consider caching/storing link validity to avoid repeated checks

## Priority Functions to Link

High-value links (most commonly used):

**Core analysis:**
- `chisq.test()`, `fisher.test()` (stats)
- `glm()`, `anova()` (stats)
- `goodfit()`, `assocstats()`, `oddsratio()` (vcd)
- `mosaic()`, `fourfold()`, `sieve()`, `assoc()` (vcd)
- `loglm()` (MASS)
- `ca()` (ca)

**Model fitting:**
- `polr()`, `glm.nb()` (MASS)
- `multinom()` (nnet)
- `gnm()` (gnm)
- `zeroinfl()`, `hurdle()` (pscl)

**Effects/visualization:**
- `allEffects()`, `Effect()` (effects)
- `ggpredict()` (ggeffects)

Start with these ~25 most important functions, then expand.
