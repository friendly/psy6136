# Finding Author-Maintained Documentation Links for R Packages

## Problem Statement (StackOverflow style)

### Title: How to programmatically find pkgdown/altdoc documentation URLs for R packages?

### Question:

I'm building a reference guide for Categorical Data Analysis, https://friendly.github.io/psy6136/R-functions.html
that lists R functions for analysis and visualization. I'd like this also to include HTML links to their documentation
to make this more directly useful.

I've extracted the topics, packages, descriptions to a dataset for a new version that could include such links.
I'm currently using `rdrr.io` URLs as a default (e.g., `https://rdrr.io/cran/vcd/man/mosaic.html`), but I'd prefer to link to author-maintained documentation sites (`pkgdown`, `altdoc`) when available, as these often have better formatting, examples, and vignettes.

For example:
- `vcdExtra` package: prefer https://friendly.github.io/vcdExtra/reference/mosaic.glm.html over `rdrr.io`
- `ggplot2`: prefer https://ggplot2.tidyverse.org/reference/ over `rdrr.io`
- `dplyr`: prefer https://dplyr.tidyverse.org/reference/ over `rdrr.io`

**Given a list of function/package names, how can I programmatically find the "best" documentation URL?**

The DESCRIPTION file's `URL:` field often contains this information. For example:

```
URL: https://friendly.github.io/vcdExtra/, https://github.com/friendly/vcdExtra
```

But parsing this requires:
1. Identifying which URL is the documentation site vs. the source repo
2. Handling packages that don't have a pkgdown site
3. Constructing function-specific URLs from the base site URL

### What I've considered:

1. **Parse local DESCRIPTION files** - Scan all my installed packages' DESCRIPTION files for the `URL:` field
2. **Query CRAN metadata** - Use `available.packages()` or the CRAN API
3. **Special pkgs**: 
  - The `pkgsearch` package might help query CRAN metadata
  - The `desc` package provides nicer DESCRIPTION file parsing
  

### Desired output:

A function or approach that, given a package name and function name, returns the best available documentation URL, preferring author sites over `rdrr.io`.

```r
get_doc_url("mosaic.glm", "vcdExtra")
# Returns: "https://friendly.github.io/vcdExtra/reference/mosaic.glm.html"

get_doc_url("chisq.test", "stats")
# Returns: "https://rdrr.io/r/stats/chisq.test.html"  # fallback for base R
```

---

## Possible Approaches

### 1: Parse DESCRIPTION files from installed packages

Just a sketch:

```r
get_pkg_urls <- function(pkg) {
  desc_path <- system.file("DESCRIPTION", package = pkg)
  if (desc_path == "") return(NULL)

  desc <- read.dcf(desc_path)
  urls <- desc[, "URL", drop = TRUE]
  if (is.na(urls)) return(NULL)

  # Split on comma or whitespace
  strsplit(urls, "[,\\s]+")[[1]]
}

# Example
get_pkg_urls("vcd")
# [1] "https://friendly.github.io/vcdExtra/" "https://github.com/friendly/vcdExtra"
```

### 2: Identify pkgdown sites from URL patterns

pkgdown sites typically:
- End with the package name in the path
- Have a `/reference/` subdirectory
- Common patterns: `*.github.io/pkgname`, `pkgname.r-lib.org`

```r
is_pkgdown_url <- function(url, pkg) {
  patterns <- c(
    sprintf("\\.github\\.io/%s/?$", pkg),
    sprintf("%s\\.r-lib\\.org/?$", pkg),
    sprintf("tidyverse\\.org/?$"),
    "/reference/?$"
  )
  any(sapply(patterns, grepl, x = url, ignore.case = TRUE))
}
```

### Approach 3: Test URLs for validity

```r
url_exists <- function(url) {
  tryCatch({
    response <- httr::HEAD(url, httr::timeout(5))
    httr::status_code(response) == 200
  }, error = function(e) FALSE)
}

# Test if reference page exists
test_pkgdown_ref <- function(base_url, fun_name) {
  ref_url <- paste0(sub("/$", "", base_url), "/reference/", fun_name, ".html")
  if (url_exists(ref_url)) ref_url else NULL
}
```

---

## Challenges

1. **Not all packages have pkgdown sites** - Need graceful fallback to rdrr.io
2. **URL field inconsistency** - Some packages list only GitHub, some list multiple URLs
3. **Function name mapping** - Some functions are documented together (e.g., `dbinom`, `pbinom` are on the same page)
4. **S3 methods** - `plot.ca` might be documented as `plot.ca.html` or under `plot.html`
5. **Base R packages** - No pkgdown sites; rdrr.io or r-project.org are the only options
6. **Bioconductor packages** - Different URL patterns

---

## Packages in scope

For my specific use case, these are the key packages needing documentation links:

**Core packages (likely have pkgdown sites):**
- vcd, vcdExtra, ca, effects, ggeffects, car

**MASS and stats:** Base R, use rdrr.io

**Modeling packages:**
- gnm, logmult, nnet, ordinal, VGAM, pscl, nestedLogit

**Visualization:**
- ggmosaic, sjPlot, factoextra, GGally, ggalluvial

**Utilities:**
- DescTools, broom, psych, lmtest, AER, ResourceSelection, pROC

---

## Notes

- The `pkgsearch` package might help query CRAN metadata
- The `desc` package provides nicer DESCRIPTION file parsing
- Could build a lookup table/cache rather than querying live each time
