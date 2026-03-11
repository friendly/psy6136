# Plan: Data-Driven Tables for R-functions.Rmd

## Goal

Replace the manually-written markdown tables in `R-functions.Rmd` with tables generated programmatically from `data/CDA_functions.csv`. This allows:

- Single source of truth for function information
- Easy updates to links, descriptions, packages
- Consistent formatting across all tables
- Ability to add/modify functions without editing markdown

## Step 1: Make CDA_functions.csv a Project Dataset

Options:
1. **Keep as CSV in `data/`** - Load with `read.csv()` in setup chunk
2. **Convert to .rda** - Save as `data/CDA_functions.rda` for faster loading
3. **Include in a package** - If this becomes part of vcdExtra or similar

Recommendation: Keep as CSV for transparency and easy editing, load once in setup chunk.

## Step 2: Create Helper Functions

In a setup chunk or sourced R file (e.g., `R/table_helpers.R`):

```r
# Load the data
CDA_functions <- read.csv("data/CDA_functions.csv", stringsAsFactors = FALSE)

# Function to create a linked function name
link_function <- function(fun, link) {


  sprintf("[`%s`](%s)", fun, link)
}

# Function to generate a table for a specific Topic and Method
make_table <- function(data, topic, method = NULL,
                       cols = c("Tag", "Function", "Package", "Description")) {

  # Filter by topic

  subset <- data[data$Topic == topic, ]


  # Optionally filter by method
 if (!is.null(method)) {
    subset <- subset[subset$Method == method, ]
  }

  # Create linked function names
  subset$Function <- mapply(link_function, subset$Function, subset$Link)

  # Select and rename columns
  # Map Tag -> original column header (Method, Plot Type, etc.)
  result <- subset[, cols, drop = FALSE]

  # Use Tag value as first column header if it varies
  # Or use a fixed header based on the table type

  knitr::kable(result, row.names = FALSE)
}
```

## Step 3: Define Table Specifications

Each table in R-functions.Rmd needs:
- Topic filter (e.g., "Discrete Distributions")
- Method filter (e.g., "Fitting", "Visualization")
- Column selection and headers

Example mapping:

| Section | Topic | Method | Columns | First Col Header |
|---------|-------|--------|---------|------------------|
| 1. Fitting Distributions | Discrete Distributions | Fitting | Tag, Function, Package, Description | Method |
| 1. Distribution Functions | Discrete Distributions | Distribution | Tag, Function, Package | Distribution |
| 1. Visualization | Discrete Distributions | Visualization | Tag, Function, Package, Description | Plot Type |
| 2. Tests of Independence | Two-Way Contingency Tables | Testing | Tag, Function, Package, Description | Test |
| ... | ... | ... | ... | ... |

## Step 4: Replace Tables in R-functions.Rmd

Current structure:
```markdown
### Fitting Distributions

| Method | Function | Package | Description |
|--------|----------|---------|-------------|
| Goodness-of-fit test | `chisq.test()` | stats | Chi-square test... |
...
```

New structure:
```markdown
### Fitting Distributions

```{r, echo=FALSE, results='asis'}
make_table(CDA_functions,
           topic = "Discrete Distributions",
           method = "Fitting",
           header1 = "Method")
```
```

## Step 5: Handle Special Cases

### Tables with different column structures

Some tables have different columns:
- Distribution Functions: Distribution | Functions | Package (no Description)
- vcd Core Functions: Function | Description (no Method, no Package column shown)
- ggplot2 Extensions: Package | Function | Description

Solution: Make `cols` parameter flexible, allow custom column names.

### Multiple functions in one cell

Some rows have comma-separated functions (e.g., "dbinom(), pbinom(), qbinom(), rbinom()").
These share a single link. Current CSV handles this - just display as-is.

### Tag as column header

The Tag field contains the original column header (Method, Plot Type, Test, etc.).
The helper function should use this to set the appropriate column name.

## Step 6: Suggested File Organization

```
psy6136/
├── data/
│   └── CDA_functions.csv      # The dataset
├── R/
│   └── table_helpers.R        # Helper functions (optional, could be in .Rmd)
├── R-functions.Rmd            # Main document with generated tables
└── notes/
    └── data-driven-tables-plan.md  # This file
```

## Implementation Order

1. [ ] Verify CDA_functions.csv is complete and correct
2. [ ] Create helper function(s) in R-functions.Rmd setup chunk
3. [ ] Test with one section (e.g., Discrete Distributions)
4. [ ] Iterate on formatting (column widths, link styling)
5. [ ] Replace remaining sections
6. [ ] Remove old static table markdown
7. [ ] Test full document render

## Open Questions

1. **Caching**: Should tables be cached to speed up rendering?
2. **Link validation**: Add a script to verify all links work?
3. **Sorting**: Should functions be sorted within tables? (Currently in manual order)
4. **Duplicate entries**: Some functions appear multiple times (e.g., `mosaic()` in Two-Way and Loglinear). Is this intentional?

## Example Output

For "Discrete Distributions > Fitting", the generated table would look like:

| Method | Function | Package | Description |
|--------|----------|---------|-------------|
| Goodness-of-fit test | [`chisq.test()`](https://rdrr.io/r/stats/chisq.test.html) | stats | Chi-square test for discrete distributions |
| Goodness-of-fit test | [`goodfit()`](https://rdrr.io/cran/vcd/man/goodfit.html) | vcd | Fit and test discrete distributions |
| ... | ... | ... | ... |

The function names become clickable links to their documentation.
