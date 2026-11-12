---
paths:
  - "**/*.R"
  - "**/*.py"
  - "**/*.jl"
  - "**/*.do"
  - "**/*.qmd"
  - "**/*.tex"
  - "paper/tables/**"
  - "paper/figures/**"
  - "reference_docs/**"
  - "explorations/**"
---

# Content Standards: Tables, Figures, PDFs, and Explorations

------------------------------------------------------------------------

## 1. Table Standards

**Target:** Publication-quality tables using standard economics formatting (booktabs rules, no vertical rules). Table 1, float placement, and the canonical table chunk follow `.claude/rules/paper-organization.md` (house style); this section covers the table body. Three approaches in priority order:

1. **`fixest::etable` or `modelsummary`** — primary workflow for all regression and descriptive tables. The R script fits the models and saves them as `.rds` to `paper/tables/`; the `etable()`/`modelsummary()` call itself happens in the `main.qmd` chunk that loads the `.rds`, not in the script (INV-13). Output is a `threeparttable` (etable default) or bare `tabular` rendered inline in `main.qmd`.
2. **`tabular` + `booktabs` + `threeparttable`** — traditional wrapping stack, produced by the same qmd-side `etable()`/`modelsummary()` call above. Not something the script writes directly.
3. **tabularray (`tblr` / `talltblr`)** — fallback only, for hand-written tables that can't be generated from R code.

Journal-specific conventions (significance stars, note format) adapt to the target journal — see journal-profiles.md.

### No In-Table Titles or Notes

- **Never** embed titles inside the table body or as a table header row
- **Never** embed notes, sources, or footnotes inside the table itself
- Table numbering, titles, and notes are added by the table's chunk in `main.qmd` (`tbl-cap` / `etable(title=)`, `etable(notes=)` / `footnote()`) — see `paper-organization.md` §3 (INV-25)
- The file name and folder identify what the table contains

### Three-Line Format (Booktabs)

Every table uses exactly three horizontal rules and **zero vertical lines**:

**Traditional (what `etable()`/`kbl()` render in the `main.qmd` chunk — never hand-written, never `\label{}`; the chunk's `tbl-` label carries the cross-reference):**

``` latex
\begin{table}[!t]
\centering
\begin{threeparttable}
\caption{Effect of X on Y}
\begin{tabular}{lcccc}
\toprule
            & (1)     & (2)     & (3)     & (4)     \\
\midrule
...coefficients...
\bottomrule
\end{tabular}
```

**Modern (hand-written in main.qmd raw LaTeX block):**

``` latex
\begin{talltblr}[
  caption = {Effect of X on Y},
  note{*} = {Sample: ... (INV-1).},
]{colspec = {lcccc}, rowsep = 4pt}
\toprule
            & (1)     & (2)     & (3)     & (4)     \\
\midrule
...coefficients...
\bottomrule
\end{talltblr}
```

- `\toprule` above column headers
- `\midrule` below column headers (and to separate panels)
- `\bottomrule` at the very end
- `\cmidrule(lr){2-4}` for partial rules spanning column groups
- **Never** use `\hline`, `|`, or any vertical rules

### Coefficient Display

- Point estimates on one row, standard errors in parentheses on the row below
- The SE type/clustering and star thresholds are printed by `etable()`'s footer (or `modelsummary`'s `stars` note). Do **not** repeat them in the table notes (INV-1); a hand-built `kbl()` table without such a footer states them once in its note.

**Significance reporting in tables depends on the target journal** (prose never quotes p-values, and quotes SEs only when precision is the point, whatever the journal — see `.claude/references/writing-practice.md` WP-1):

| Context | Convention |
|---------------------------------|---------------------------------------|
| **Working papers (default)** | Stars: `*` p \< 0.10, `**` p \< 0.05, `***` p \< 0.01, defined in the estimator's footer |
| **AEA journals** (AER, AEJ:Applied, AEJ:Policy, AER:Insights) | No significance stars. Report standard errors in parentheses. Use exact p-values or confidence intervals for key results. See the [AEA Style Guide](https://www.aeaweb.org/journals/aeri/style-guide). |
| **All other journals** | Stars acceptable. Follow journal-specific conventions in journal-profiles.md. |

Working paper default example:

```         
Treatment        & 0.045**  & 0.038*   & 0.052*** \\
                 & (0.021)  & (0.020)  & (0.019)  \\
```

AEA journal example:

```         
Treatment        & 0.045    & 0.038    & 0.052    \\
                 & (0.021)  & (0.020)  & (0.019)  \\
```

### Column and Row Structure

- **Column (1), (2), ...** headers in the first row after `\toprule`
- **Dependent variable** stated in a spanning header or the first subheader row
- **Variable names** left-aligned, human-readable (not raw R variable names)
  - `Log wages` not `ln_wage_deflated`
  - `Female` not `sex_2`
  - `Years of education` not `educ_yrs`
- **Numeric columns** right-aligned or decimal-aligned
- **N**, **R²**, **Fixed effects** (Yes/No), **Controls** (Yes/No) at the bottom before `\bottomrule`

### Panel Structure

For tables with multiple panels:

``` latex
\multicolumn{5}{l}{\textit{Panel A: Full sample}} \\
\midrule
...
\\[0.5em]
\multicolumn{5}{l}{\textit{Panel B: Male workers}} \\
\midrule
...
```

- Panel labels in italics, left-aligned, spanning all columns
- `\midrule` after each panel label
- Small vertical space (`\\[0.5em]`) between panels

### Preferred R Packages

The script fits the models and saves them as a named list `.rds` to `paper/tables/`. The calls below run in the `main.qmd` chunk that loads that `.rds` — not in the script.

**Primary: `fixest::etable`** (all models are `fixest` fits)

``` r
models <- readRDS(here("paper", "tables", "estimation", "reg_main_specification.rds"))

fixest::etable(
  models,
  tex      = TRUE,
  style.tex = style.tex(
    main     = "aer",
    depvar.title = "",
    fixef.title  = "",
    yesNo    = c("Yes", "No")
  ),
  se.below = TRUE,
  signif.code = c("***" = 0.01, "**" = 0.05, "*" = 0.10)  # omit for AEA journals
)
```

**Alternative: `modelsummary`** (mixed estimators — lm, ivreg, fixest, etc.)

``` r
models <- readRDS(here("paper", "tables", "estimation", "reg_mixed_specification.rds"))

modelsummary(
  models,
  output   = "latex_tabular",  # bare tabular, no wrapper
  stars    = c("*" = 0.10, "**" = 0.05, "***" = 0.01),  # set FALSE for AEA journals
  coef_rename = c(
    "treatment"  = "Treatment",
    "log_income" = "Log income"
  ),
  gof_map = c("nobs", "r.squared", "adj.r.squared"),
  escape  = FALSE
)
```

**For summary / descriptive tables: `kableExtra`**

Caption via the Quarto chunk options (`tbl-cap:`), never `\caption{}` inside the pipeline — this keeps `@tbl-` cross-references working (INV-10). Notes via `footnote()`, not a bare comment or in-cell text — this satisfies the every-table-has-notes requirement (INV-1).

```` markdown
```{r}
#| label: tbl-summary-stats
#| tbl-cap: "Summary Statistics"
#| tbl-pos: "!t"
#| output: asis

kbl(df, format = "latex", booktabs = TRUE, escape = FALSE,
    align = c("l", rep("c", ncol(df) - 1))) %>%
  footnote(
    general = "Sample restricted to ... (data source goes in the prose, INV-1)",
    general_title = "Note: ",
    title_format = c("italic"),
    threeparttable = TRUE,
    footnote_as_chunk = TRUE,
    escape = FALSE
  )
```
````

### Number Formatting

- **Coefficients:** 3 decimal places (e.g., `0.045`)
- **Standard errors:** 3 decimal places in parentheses (e.g., `(0.021)`)
- **Observation counts and large integers:** comma thousands separator (e.g., `10,453`)
- **Percentages in text:** 1 decimal place (e.g., `48.2%`)
- These are the etable/modelsummary defaults — set once via `options()` in the script preamble if needed

### Typography

- Serif font throughout (inherits from document class — no extra commands needed)
- `\small` or `\footnotesize` for tables that need to fit within column width
- Variable names in plain text, panel labels in `\textit{}`
- Never bold table body content; bold only for rare emphasis in headers

### Export

``` r
# Save the fitted models (or summary-stats data frame), not a rendered table
saveRDS(models, file.path("paper/tables", "reg_main_specification.rds"))
```

- Save the **model objects** — never a script-side `etable()`/`modelsummary()` call, never rendered `.tex`
- The paper's `main.qmd` loads the `.rds` and calls the styling function with `tex = TRUE`/`output = "latex_tabular"`, stars, and notes
- Write to `paper/tables/`

### File Naming

```         
tables/
├── descriptive/
│   ├── sumstats_main_sample.rds
│   └── balance_treatment_control.rds
├── estimation/
│   ├── reg_main_specification.rds
│   ├── reg_heterogeneity_gender.rds
│   └── did_event_study_coefficients.rds
└── robustness/
    └── reg_alternative_controls.rds
```

Pattern: `{table_type}_{content_description}.rds`

- `sumstats_` for summary statistics
- `balance_` for balance / pre-treatment tests
- `reg_` for regression output
- `did_` for difference-in-differences specific tables
- `first_stage_` for IV first stage

### Prohibited Patterns

| Pattern | Reason |
|--------------------------------------|----------------------------------|
| Title row inside the table | Titles go in `\caption{}`, not the table body |
| Notes embedded in table body | Notes go below via `\begin{tablenotes}` |
| `\hline` | Use `\toprule` / `\midrule` / `\bottomrule` (booktabs) |
| Vertical rules (`\|` in column spec) | Never used in economics journals |
| `stargazer` package | Deprecated workflow; use `modelsummary` or `fixest::etable` |
| Raw variable names in labels | Human-readable labels required |
| `xtable` without booktabs | Produces non-journal-quality output |
| `etable()`/`modelsummary()` called inside the R script | Bakes styling in; restyling requires a re-run. Script saves `.rds` model objects, styling call lives in `main.qmd` (INV-13) |

### Table Type Templates

Use these as defaults. Adapt columns based on the paper's needs (e.g., add Min/Max, percentiles, or subgroup columns when substantively important).

**Descriptive Statistics** (full-sample or appendix summary statistics; Table 1 follows `paper-organization.md` §2):
```
\toprule
                        &  Mean   &  SD     \\
\midrule
\multicolumn{3}{l}{\textit{Continuous variables}} \\
\quad Wages (USD)       &  45,230 &  12,400 \\
\quad Years of education&  13.2   &  2.8    \\
\quad Age               &  38.5   &  11.2   \\
\\[0.5em]
\multicolumn{3}{l}{\textit{Categorical variables (\%)}} \\
\quad Female            &  48.2   &         \\
\quad College degree    &  32.5   &         \\
\bottomrule
```

- Default: Mean and SD in separate columns (never stacked with parentheses — that's for regression SEs)
- Categorical/binary: percentage in Mean column, SD blank
- Sample size stated once in table notes, not as a column
- Add Min/Max only when the range is substantively important (RDD bandwidth, data coverage)

**Regression Results:**

```         
\toprule
                        &  (1)    &  (2)    &  (3)    &  (4)    \\
                        &  OLS    &  OLS    &  IV     &  IV     \\
\midrule
Treatment               &  0.045**&  0.038* &  0.052**&  0.041* \\
                        & (0.021) & (0.020) & (0.025) & (0.022) \\
\midrule
Controls                &  No     &  Yes    &  No     &  Yes    \\
Fixed Effects           &  No     &  Yes    &  No     &  Yes    \\
Observations            &  10,000 &  10,000 &  10,000 &  10,000 \\
R$^2$                   &  0.05   &  0.12   &         &         \\
\bottomrule
```

- Coefficients on one row, standard errors in parentheses below
- Stars: `*` p \< 0.10, `**` p \< 0.05, `***` p \< 0.01
- Bottom rows: Controls (Yes/No), Fixed Effects (Yes/No), Observations, R²

**Multi-Outcome (Panel Structure):**

```         
\toprule
                        &  (1)    &  (2)    &  (3)    &  (4)    \\
\midrule
\multicolumn{5}{l}{\textit{Panel A: Wages}} \\
\midrule
Treatment               &  0.045**&  0.038* &  0.052**&  0.041* \\
                        & (0.021) & (0.020) & (0.025) & (0.022) \\
\\[0.5em]
\multicolumn{5}{l}{\textit{Panel B: Employment}} \\
\midrule
Treatment               &  0.021  &  0.033* &  0.015  &  0.028  \\
                        & (0.018) & (0.017) & (0.020) & (0.019) \\
\midrule
Controls                &  No     &  Yes    &  No     &  Yes    \\
Fixed Effects           &  No     &  Yes    &  No     &  Yes    \\
Observations            &  10,000 &  10,000 &  10,000 &  10,000 \\
\bottomrule
```

- Each outcome gets its own panel with same column structure
- Panel labels in italics, left-aligned, spanning all columns
- Controls/FE/Observations rows appear once at the bottom (shared across panels)

**Appendix balance tests** (not Table 1, which has only treated and control columns — INV-24):
```
\toprule
Variable                &  Treatment &  Control &  Difference &  SE     &  p-value \\
\midrule
Wages (USD)             &  45,800    &  44,650  &  1,150      &  (890)  &  0.197   \\
Years of education      &  13.4      &  13.1    &  0.3        &  (0.2)  &  0.134   \\
Female (\%)             &  47.8      &  48.6    &  -0.8       &  (1.2)  &  0.505   \\
\bottomrule
```

**Robustness:**

```         
\toprule
                        &  (1)        &  (2)           &  (3)          &  (4)            \\
                        &  Baseline   &  Alt. controls &  Alt. sample  &  Alt. estimator \\
\midrule
```

- Column headers describe what changes across specifications
- Same outcome variable across all columns

------------------------------------------------------------------------

## 2. Figure Standards

- **Never add titles or subtitles inside ggplot** — use `labs(title = NULL, subtitle = NULL)`
- **Figure information goes in two places:**
  1.  **File name** — descriptive, e.g., `fig1_hispanic_enrollment_ascm.pdf`
  2.  **Quarto `fig-cap` chunk option** — the authoritative caption, numbered and editable without re-running R
- **Panel labels are the exception** — "Panel A: Employment" inside multi-panel figures (via `patchwork`, `cowplot`, etc.) is fine since they identify sub-panels, not the whole figure
- **Axis labels must be publication-quality** — "Employment Rate" not "emp_rate". Clean labels stay in the figure; titles and context go in the caption
- **Default theme: `theme_minimal(base_family = "serif")`** — use this as the baseline for all paper figures. Override only with explicit justification.
- **Use serif fonts** — figures should match the paper's body text. In ggplot, `theme_minimal(base_family = "serif")` handles this automatically.
- **Show all years on the x-axis** when the panel spans \~20 years or fewer — use `scale_x_continuous(breaks = min_year:max_year)`. Only thin out labels when they overlap (roughly \>20 ticks)
- **Output PDF for figures** — vector graphics for LaTeX. Use `ggsave("fig.pdf")`. PNG only for raster content (maps, photos).
- **Color-independent design** — figures must be readable in grayscale. Combine color with shape (`shape` aesthetic) and linetype (`linetype` aesthetic) so series remain distinguishable without color.
- **Colorblind-safe** — never rely on red/green contrast alone. The project palette avoids pure red/green pairs; when overriding with other palettes, verify with a colorblind simulator or use `viridis`/`Set2`.

### Color Palette

Green-forward theming is the **soft default** — use it as the first pass when building figure code. Override freely when the data demands it: diverging color scales for maps, `viridis`/`plasma` for continuous density, `Set2` for 5+ unordered categories.

The palette is defined in `_brand.yml` (project root) and mirrored in `paper/preambles/`. Use these exact hex codes for consistency across figures, slides, and web output:

| Role | Name | Hex | Notes |
|------|------|-----|-------|
| **Primary series** | medium-green-grey | `#5A8567` | First series, structure color in slides |
| **Dark anchor** | dark-green | `#314F40` | Second series, primary color on website |
| **Light fill** | light-green-grey | `#A3B4A9` | Confidence bands, secondary fills |
| **Background fill** | bg-green-grey | `#DDE5DC` | Shaded regions, background panels |
| **Contrast accent** | burgundy | `#590925` | Use when a non-green contrast is needed |
| **Secondary accent** | light-burgundy | `#AF3257` | Tertiary series or highlights |

**ggplot usage:**

```r
# Single series
scale_color_manual(values = c("#5A8567"))
scale_fill_manual(values  = c("#5A8567"))

# Two series (green + burgundy)
scale_color_manual(values = c("#5A8567", "#590925"))

# Multi-series: build from palette vector
project_pal <- c("#314F40", "#5A8567", "#A3B4A9", "#590925", "#AF3257", "#E7729D")
scale_color_manual(values = project_pal)
```

**When to override:** continuous variables on maps → `viridis` or `scale_fill_distiller`; 5+ unordered categories where green shades blur → `scale_color_brewer(palette = "Set2")`; any case where the data story is clearer without green-forward theming.
- **Figure width** — single-panel: `width=0.8\textwidth`. Side-by-side panels: `width=0.48\textwidth` each.

------------------------------------------------------------------------

## 3. PDF Processing

Read PDFs in `reference_docs/` with the Read tool, passing `pages` ranges (up to 20 pages per
call) for longer documents; charts and tables in the PDF are read directly. If a read fails, split
the file with `gs` or `pdftk ... burst` and read the parts.

------------------------------------------------------------------------

## 4. Exploration Folder Protocol

**All experimental work goes into `explorations/` first.** Never directly into production folders.

### Folder Structure

```         
explorations/
├── ACTIVE_PROJECTS.md
├── [project]/
│   ├── README.md          # Goal, status, findings
│   ├── R/                 # Code (use _v1, _v2 for iterations)
│   ├── scripts/           # Test scripts
│   ├── output/            # Results
│   └── SESSION_LOG.md     # Progress notes
└── ARCHIVE/
    ├── completed_[project]/
    └── abandoned_[project]/
```

### Lifecycle

1.  **Create** — `mkdir -p explorations/[name]/{R,scripts,output}` + README from `templates/exploration-readme.md`

2.  **Develop** — work entirely within the exploration folder

3.  **Decide:**

    - **Graduate to production** — copy to `R/`, `scripts/`; requires quality \>= 80, tests pass, code clear. Move to `ARCHIVE/completed_[project]/`
    - **Keep exploring** — document next steps in README
    - **Abandon** — move to `ARCHIVE/abandoned_[project]/` with explanation (use `templates/archive-readme.md`)

### Graduate Checklist

- [ ] Quality score \>= 80
- [ ] All tests pass
- [ ] Results replicate within tolerance
- [ ] Code is clear without deep context
- [ ] README explains approach and findings

------------------------------------------------------------------------

## 5. Exploration Fast-Track

**Lightweight workflow for experimental work.** Quality threshold: 60/100 (vs 80 for production). No planning needed.

### Steps

1.  **Research value check** — Does this improve the project? If NO, don't build it.
2.  **Create folder** — `mkdir -p explorations/[name]/{R,scripts,output}` + README + SESSION_LOG.md
3.  **Code immediately** — no plan needed. Must-haves: code runs, results correct, goal documented. Not needed: Roxygen docs, full tests, perfect style.
4.  **Log progress** — append 2-3 lines to SESSION_LOG.md as you work
5.  **Decision point** — keep exploring, graduate to production (upgrade to 80/100), or archive with brief explanation

### When to Stop (Kill Switch)

At any point: stop, archive with note ("Attempted X, hit blocker Y"), move on. No guilt — exploration is inherently uncertain.