---
paths:
  - "paper/**"
  - "**/*.qmd"
  - "**/*.tex"
---

# Paper Organization — House Style (Tables, Figures, Structure)

This is the house layout for every paper in this project (content invariants INV-23, INV-24, INV-25),
translated from upstream clo-author's LaTeX house style to this fork's Quarto workflow. Follow it
unless the user asks otherwise: the writer-critic deducts for deviations and the verifier fails on
them. It is the single source for float placement, Table 1, the table and figure chunks, and section
order; `working-paper-format.md` covers Quarto mechanics (YAML, citations, cross-reference syntax).

**Reference exemplars.** Keep one or two well-organized prior papers (e.g. in
`reference_docs/my_papers/`) as the local gold standard and open them when a case isn't covered here.

---

## 1. Float placement — collect at the END, never inline (INV-23)

Section files (`paper/sections/*.qmd`) contain **only prose and `@tbl-`/`@fig-` cross-references —
no exhibits.** No chunk with a `tbl-`/`fig-` label, no `![...](...){#fig-...}` image, no
`{=latex}` table or figure block. All tables and figures live in `paper/main.qmd`, in two blocks
placed **after** the references div:

````markdown
{{< include sections/01_introduction.qmd >}}
{{< include sections/02_background.qmd >}}
...                                          <!-- all text, no exhibits -->

\clearpage

# References {.unnumbered}

::: {#refs}
:::

<!-- ============================================================ -->
<!-- TABLES                                                       -->
<!-- ============================================================ -->

\clearpage

```{r}
#| label: tbl-pretreatment
...                                          <!-- one chunk per table, \clearpage between large ones -->
```

<!-- ============================================================ -->
<!-- FIGURES                                                      -->
<!-- ============================================================ -->

\clearpage

```{r}
#| label: fig-event-study
...                                          <!-- one chunk per figure -->
```
````

- Large exhibits get their own page: `\clearpage` between them (`fig-pos: "p"` on a chunk where needed).
- Wide tables/figures: wrap the chunk in raw `{=latex}` `\begin{landscape}` / `\end{landscape}`
  (load `pdflscape` in `paper/preambles/draft-article/article-header.tex`).
- The reader navigates by `@tbl-x` / `@fig-y` from the text; Quarto numbers and links them.
- Appendix exhibits follow the same convention at the end of `paper/appendix.qmd`.

## 2. Table 1 is pre-treatment characteristics (INV-24)

**When the design compares a treated and a control group**, the first table describes the sample as a
**two-group comparison at baseline**:

- **Two value columns only: treated and control. No difference column, no SD column, no p-value.**
  Group means / percentages, one value per cell. Balance *tests* go in an appendix table.
- Rows grouped into **thematic panels** (panel label row + `\midrule`), e.g. *Demographics*,
  *Economic structure*, *Sector composition (%)*.
- **Bottom rows:** unit counts (e.g. `Counties`, `Individuals`) — the N lives here, not in a column.
- Caption names the baseline window: e.g. "Pre-Treatment Characteristics, 1860".

The script saves a summary data frame (`.rds`, INV-13), not a rendered table; `main.qmd` styles it:

````markdown
```{r}
#| label: tbl-pretreatment
#| tbl-cap: "Pre-Treatment Characteristics, 1860"
#| output: asis

t1 <- readRDS(here("paper", "tables", "01_descriptives", "pretreatment_characteristics.rds"))
kbl(t1, format = "latex", booktabs = TRUE, align = c("l", "c", "c"),
    col.names = c("", "Treated Group", "Control Group")) |>
  pack_rows(index = attr(t1, "panels")) |>
  footnote(general = "...", general_title = "Notes: ", threeparttable = TRUE)
```
````

With a continuous treatment or no control group, Table 1 is the main-sample summary statistics
table; the rest of this section does not apply.

## 3. Canonical table chunk (INV-25)

Scripts save model objects or summary data frames as `.rds` (INV-13). Every table in `main.qmd` is
one chunk that loads the `.rds` and calls the styling function — the "wrapper" is that chunk:

- `#| label: tbl-...` and a caption: a **full descriptive title in title case**, method or cohort in
  parentheses (`etable(title = ...)` or `#| tbl-cap:`).
- `#| output: asis`; `etable(..., tex = TRUE)` / `modelsummary(..., output = "latex")` /
  `kbl(..., booktabs = TRUE)` per `working-paper-format.md` § Tables.
- **Notes** via `etable(notes = ...)`, `modelsummary(notes = ...)`, or `kableExtra::footnote(threeparttable = TRUE)`.
  Notes follow **INV-1** (roughly 40–70 words: what the table shows, how to read it, sample details
  the table does not print; data sources in the prose). This fork's INV-1 overrides upstream's
  "exhaustive notes".
- Booktabs rules only, no `\hline`, no vertical rules (INV-3). Stars per the journal profile (INV-4).
- "Total effect" rows (base + interaction) report **delta-method SEs in brackets**.
- Hand-written tables: a raw `{=latex}` `talltblr` block with `note{}` keys (`working-paper-format.md`).

## 4. Canonical figure chunk (multi-panel)

````markdown
```{r}
#| label: fig-event-study
#| fig-cap: "Event Study: County Outcomes (Sun-Abraham)"
#| fig-cap-location: top
#| fig-subcap:
#|   - "Panel title A"
#|   - "Panel title B"
#| layout-ncol: 2

knitr::include_graphics(here("paper", "figures", "03_event_study", c("panel_a.pdf", "panel_b.pdf")))
```
````

- The overall caption sits at the **top**; sub-captions are short panel labels. Captions follow INV-2.
- Exported PDFs are **bare** — no titles inside the plot (INV-12). Use `layout-ncol: 3` for 3-up.
- Single panel: one path, `out-width: "80%"`. Vector PDF (PNG only for maps/rasters).

## 5. Section order

Standard structure (omit or merge as the paper needs):

1. Introduction (related literature as a subsection or folded in)
2. Background / Institutional Setting
3. Data (sources, descriptive statistics)
4. Identification / Empirical Strategy (design, specification, event study)
5. Results (main results first, then event study, heterogeneity, ...)
6. Mechanism (when present)
7. Robustness
8. Discussion
9. Conclusion

Each section is `## Title {#sec-name}` so `@sec-name` resolves.

## 6. Caption and file naming

- Captions are full descriptive titles in title case, method/cohort in parentheses:
  *"Main Results: County Wealth and Unrest (1860 Cohort)"*, *"Pre-Treatment Characteristics, 1860"*.
- Exhibits are organized **by script** (CLAUDE.md Output Organization): `paper/tables/NN_name/*.rds`,
  `paper/figures/NN_name/*.pdf`. The script writes the bare exhibit; `main.qmd` owns numbering,
  caption, and notes.

## 7. Exhibit numbering

- **Table 1:** pre-treatment characteristics (§2), or summary statistics.
- **Table 2:** main results.
- Then mechanism → heterogeneity → robustness.
- **Figures:** context/maps first, then main event studies, then heterogeneity / dose-response / placebo.
