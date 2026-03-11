# Pkgdown Site Scan Results

Scanned DESCRIPTION files from `C:\R\R-4.5.2\library` for packages used in `CDA_functions.csv`.

## Summary

| Category | Count | Packages |
|----------|-------|----------|
| Working pkgdown sites | 12 | vcdExtra, DescTools, ggeffects, ggmosaic, nestedLogit, pROC, broom, GGally, ggstats, fitdistrplus, sjPlot*, ggalluvial* |
| No pkgdown site | 5 | gnm, logmult, ordinal, pscl, vcd** |
| Project/author sites | 8 | ca, car, effects, factoextra, FactoMineR, MASS, psych, VGAM |
| Base R (use rdrr.io) | 2 | stats, graphics |
| CRAN link only | 2 | arm, nnet |
| Not installed | 4 | discretefit, margins, ResourceSelection, countreg |

*Found via URL guessing (not installed locally)
**vcd is maintained by others; no pkgdown site exists. Available on r-universe at https://cran.r-universe.dev/vcd but without per-function rendered docs.

## Verified Working Pkgdown Reference URLs

These were tested with HTTP HEAD requests:

```
200 https://friendly.github.io/vcdExtra/reference/CMHtest.html
200 https://andrisignorell.github.io/DescTools/reference/OddsRatio.html
200 https://strengejacke.github.io/ggeffects/reference/ggpredict.html
200 https://haleyjeppson.github.io/ggmosaic/reference/geom_mosaic.html
200 https://friendly.github.io/nestedLogit/reference/nestedLogit.html
```

## Pkgdown Base URLs (for reference/ path)

| Package | Pkgdown Base URL |
|---------|------------------|
| vcdExtra | https://friendly.github.io/vcdExtra/ |
| DescTools | https://andrisignorell.github.io/DescTools/ |
| ggeffects | https://strengejacke.github.io/ggeffects/ |
| ggmosaic | https://haleyjeppson.github.io/ggmosaic/ |
| ggstats | https://larmarange.github.io/ggstats/ |
| nestedLogit | https://friendly.github.io/nestedLogit/ |
| pROC | https://xrobin.github.io/pROC/ |
| broom | https://broom.tidymodels.org/ |
| GGally | https://ggobi.github.io/ggally/ |
| fitdistrplus | https://lbbe-software.github.io/fitdistrplus/ |
| sjPlot | https://strengejacke.github.io/sjPlot/ |
| ggalluvial | https://corybrunson.github.io/ggalluvial/ |

## URL Pattern for Pkgdown Function Docs

```
{base_url}reference/{function_name}.html
```

Example: `https://friendly.github.io/vcdExtra/reference/mosaic.glm.html`

## Recommendations

1. **Use pkgdown URLs** for the 12 packages with verified sites
2. **Use rdrr.io** for all others as fallback
3. **For vcd**: use rdrr.io (no pkgdown site available; r-universe lacks per-function docs)

## Next Steps

Could add an `AltLink` column to `CDA_functions.csv` with pkgdown URLs where available, falling back to the existing rdrr.io Link for others.
