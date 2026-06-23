# Coding Standards: R

These standards apply to all R code produced by the Coder agent. Derived from C++ Core Guidelines engineering discipline, adapted for R in empirical economics. The coder-critic enforces these rules.

---

## 1. Runtime and Dependencies

- **R >= 4.3.0** (`\(x)` lambda syntax)
- **`renv`** for dependency lockfile (`renv.lock` committed)
- All packages declared and loaded at script top — no `install.packages()` in scripts

### Core Stack

| Package | Purpose |
|---------|---------|
| `data.table` | High-performance data manipulation (large merges, loops, in-place mutation) |
| `dplyr` / `tidyr` | Readable wrangling for smaller operations and exploratory work |
| `magrittr` | `%>%` pipe (required; do not use native `\|>`) |
| `fixest` | Fixed effects, event studies; use `etable` for fixest-only output tables |
| `modelsummary` | Publication tables for mixed-model output (non-fixest or multi-estimator tables) |
| `ggplot2` / `tmap` | All figures and maps |
| `here` | Project-root-relative paths |
| `furrr` | Parallel bootstrap/simulation (mirrors purrr::map syntax, future backend) |

**Table output rule:** use `fixest::etable` when all models in a table are `fixest` objects. Use `modelsummary` when mixing estimators (lm, ivreg, fixest, etc.) or for complex table layouts.

**Wrangling rule:** tibbles/dplyr are the default. Use `data.table` only when speed is demonstrably necessary: loops with in-place mutation, large joins (>100k rows), or bootstrap iteration where copying is the bottleneck. If dplyr is fast enough, prefer it. Never mix idioms within a single pipeline chain.

### Prohibited Packages

| Package | Reason | Replacement |
|---------|--------|-------------|
| `stargazer` | Deprecated, inflexible | `modelsummary` or `fixest::etable` |
| `plyr` | Superseded, namespace conflicts | `data.table` |
| `reshape` / `reshape2` | Superseded | `data.table::melt` / `dcast` |
| `xtable` (without booktabs) | Non-journal output | `kableExtra` with `booktabs = TRUE` |

---

## 2. Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Files | `snake_case.R` | `estimate_att.R` |
| Custom Functions | `snake_case`, verb prefix, `_f` suffix | `estimate_att_f()`, `test_oir_f()` |
| Variables | `snake_case`, type suffix (see below) | `n_obs`, `y_grid` |
| Constants | `UPPER_SNAKE_CASE` | `N_BOOT`, `ALPHA`, `SEED` |
| Table columns | `snake_case` (tibble, data.table, all) | `group_id`, `time_period` |
| Booleans | `is_`, `has_`, `can_` prefix | `is_treated`, `has_converged` |
| Loop indices | Short, scoped | `b` (bootstrap), `g` (group), `t` (time) |

### Type Suffixes

Append a type suffix to variable names when the object type is not obvious from context:

| Suffix | Type | Example |
|--------|------|---------|
| `_tbl` | tibble / data frame | `counties_tbl`, `panel_tbl` |
| `_dt` | data.table | `panel_dt`, `weights_dt` |
| `_sf` | sf spatial object | `county_border_sf`, `roads_sf` |
| `_rast` | raster (terra/stars) | `pop_density_rast`, `elevation_rast` |
| `_tm` | tmap object | `county_map_tm` |
| `_fit` | fitted model (fixest, lm, ivreg, etc.) | `reg_baseline_fit`, `iv_first_stage_fit` |
| `_gg` | stored ggplot object | `fig_event_study_gg` |
| `_l` | list | `boot_results_ls`, `models_ls` |
| `_mtrx` | matrix | `weights_mat`, `boot_draws_mat` |
| `_v` | named vector | `state_codes_vec` |

Omit the suffix for plain scalars and unnamed intermediate objects where the type is obvious (`n_obs`, `y_bar`, `alpha`). This list is of expected object types, but it is not exhaustive. Propose additional suffixes as needed.

---

## 3. Code Style

- **Line width:** 80 characters (hard limit for code; comments may extend to 100)
- **Indentation:** 2 spaces (no tabs)
- **Assignment:** `<-` always, never `=` (except inside function arguments)
- **Pipes:** `%>%` (magrittr) exclusively — do not use native `|>`; never mix
- **Lambdas:** `\(x)` syntax, not `function(x)`
- **Braces:** opening on same line, closing on own line

---

## 4. Numerical Discipline

The C++ principle: **never trust implicit behavior with numbers.**

### Float Comparison
```r
# WRONG
if (x == 0.1 + 0.2) ...

# RIGHT
if (abs(x - 0.3) < 1e-10) ...
# or: all.equal(x, 0.3, tolerance = 1e-10)
```

### CDF Clamping
```r
# CDF values must stay in [0, 1]
F_hat <- pmin(pmax(F_hat, 0), 1)
```

### Inverse Link Guards
```r
# Guard against qnorm(0) = -Inf, qnorm(1) = Inf
safe_link_inv <- function(p, link_inv = qnorm, eps = 1e-12) {
  p_clamped <- pmin(pmax(p, eps), 1 - eps)
  link_inv(p_clamped)
}
```

### Integer Discipline
```r
# Use 1L, 0L for integer literals (not 1, 0 which are double)
seq_len(n)    # RIGHT: safe when n == 0
1:n           # WRONG: returns c(1, 0) when n == 0
```

### Pre-allocation
```r
# RIGHT: pre-allocate
boot_results <- matrix(NA_real_, nrow = n_grid, ncol = N_BOOT)
for (b in seq_len(N_BOOT)) {
  boot_results[, b] <- estimate_weighted(...)
}

# WRONG: growing a list
results <- list()
for (b in seq_len(N_BOOT)) {
  results[[b]] <- estimate_weighted(...)
}
```

### NaN/Inf Checks
```r
stopifnot(!any(is.na(estimates)))
stopifnot(all(is.finite(estimates)))
```

---

## 5. Function Design

### Consistent API
```r
estimate_<parameter> <- function(
  data,           # data.table: required columns documented
  ...,            # design-specific arguments
  y_grid = NULL,  # evaluation points (if applicable)
  weights = NULL  # bootstrap weights (if applicable)
) {
  # Preconditions
  stopifnot(is.data.table(data))
  
  # Implementation
  
  # Return named list
  list(estimate = ..., se = ..., n_obs = ...)
}
```

### One Function Per File
Files in `functions/` contain one primary function. File name matches function name: `estimate_att.R` contains `estimate_att()`.

### Fail Fast
```r
# Preconditions at function entry
stopifnot(is.data.table(data))
stopifnot(all(c("unit_id", "group", "time", "outcome") %in% names(data)))
if (nrow(sub) == 0L) stop(sprintf("No observations for group %d, time %d", g, t))
```

### Documentation
```r
#' Estimate the Average Treatment Effect on the Treated
#'
#' @param data data.table with columns: unit_id, group, time, outcome
#' @param g integer. Treatment group.
#' @param t integer. Post-treatment period.
#' @return named list with estimate, se, n_obs
```

---

## 6. data.table Idioms

- Use `:=` for in-place column creation
- Use `.SD`, `.N`, `.GRP` for group operations
- Never `$` extraction in chains — use `[, col_name]` or `[["col_name"]]`
- `data.table::fread` / `fwrite` for I/O

---

## 7. Bootstrap and Parallelism

```r
# Parallel bootstrap with proper seed handling
library(furrr)
plan(multisession, workers = parallel::detectCores() - 1L)

boot_results <- future_map(seq_len(N_BOOT), \(b) {
  estimate_weighted(data, weights = boot_weights[, b], ...)
}, .options = furrr_options(seed = TRUE))
```

For sequential: `RNGkind("L'Ecuyer-CMRG")` before `set.seed()`.

Use `future_map()` for list output, `future_map_dbl()` / `future_map_dfr()` for typed output (mirrors purrr conventions).

---

## 8. Error Handling

- `stopifnot()` for preconditions
- `stop()` with informative messages for logic errors
- `warning()` with context for recoverable issues (small samples)
- Never silently return `NULL` or `NA`

---

## 9. Prohibited Patterns

| Pattern | Reason | Replacement |
|---------|--------|-------------|
| `setwd()` | Breaks portability | `here()` |
| `rm(list = ls())` | Breaks debugging | Restart R |
| `library()` in function bodies | Side effects | Load at script top |
| `T` / `F` | Can be overwritten | `TRUE` / `FALSE` |
| `attach()` / `detach()` | Namespace ambiguity | Explicit references |
| `<<-` | Global assignment | Pass through arguments |
| Hardcoded paths | Breaks portability | `here()` |
| `source()` with relative paths | Fragile | `here()` |
| `print()` for status | Mixes with output | `message()` |
| `cbind` / `rbind` in loops | O(n²) copies | Pre-allocate matrix |
| `1:n` | Breaks when `n == 0` | `seq_len(n)` |

---

## 10. Figure Defaults (ggplot2)

- **Default theme:** `theme_minimal()` for all paper figures
- No titles inside ggplot — titles go in the Quarto `fig-cap` chunk option
- Panel labels ("Panel A:", "Panel B:") inside multi-panel figures are fine
- PDF output for all paper figures (vector); PNG only for raster content
- Color palettes must be grayscale-safe (test with `colorblind` or desaturate check)

```r
# Standard figure setup
theme_set(theme_minimal(base_size = 11))

ggplot(data, aes(...)) +
  geom_point() +
  labs(x = "...", y = "...") +  # no title here
  theme(legend.position = "bottom")
```

---

## 11. Script Organization

Scripts follow a numbered pipeline pattern:

```
scripts/R/
  01_build_panel.R       # Data construction → data/cleaned/
  02_descriptives.R      # Summary stats and data checks
  03_estimation.R        # Main regressions → paper/tables/, paper/figures/
  04_robustness.R        # Robustness checks
  functions/             # Reusable helpers (one function per file)
    estimate_att.R
    plot_event_study.R
```

- Each numbered script is self-contained and runnable independently
- Scripts source helpers from `functions/` via `here("scripts/R/functions/", "estimate_att.R")`
- `run_all.R` (if present) calls each numbered script in order

---

## 12. Performance

- Vectorize: `vapply()` over explicit loops when possible
- Use `data.table` grouping, not `split-apply-combine`
- Pre-allocate all result containers before loops
- `data.table` modifies in place with `:=` — use it, don't copy
- Profile with `profvis::profvis()` before micro-optimizing
- The bootstrap loop is always the bottleneck — parallelize it
