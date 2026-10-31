---
name: paper-format
description: Apply and enforce the paper house style in Quarto — exhibits collected at the end of main.qmd (never in section files), Table 1 pre-treatment characteristics, canonical table/figure chunks, section order, captions. Use when building, formatting, or auditing a paper's tables, figures, or structure. Enforces INV-23/24/25.
argument-hint: "[mode: audit | scaffold | table1 | show] [target file]"
allowed-tools: Read,Grep,Glob,Write,Edit,Bash
---

# Paper Format (House Style)

Applies and enforces `.claude/rules/paper-organization.md` (blocking invariants **INV-23, INV-24,
INV-25**) on this fork's Quarto manuscript: `paper/main.qmd` plus `paper/sections/*.qmd`.

**Input:** `$ARGUMENTS` — a mode and optional target. Default mode: `audit`.

## Modes

### `audit [paper/main.qmd]` (default)
Check the paper against the house style and report violations with invariant numbers:
1. **INV-23 — exhibits at end.** Grep `paper/sections/*.qmd` for chunk labels `#| label: (tbl|fig)-`,
   image syntax `{#fig-`, and `{=latex}` blocks containing `\begin{table}`/`\begin{figure}`/`talltblr`
   → any hit is a violation. Confirm `main.qmd` has the TABLES and FIGURES banner blocks after the
   `::: {#refs}` div, and that every `tbl-`/`fig-` chunk sits inside them.
2. **INV-24 — Table 1.** If the design has treated and control groups, confirm the first table is
   pre-treatment characteristics: two group columns, thematic panels, unit counts at the bottom, and
   **no difference / SD / p-value column**. Otherwise confirm it is the summary-statistics table.
3. **INV-25 — canonical chunks.** Every table chunk loads an `.rds` and styles it in `main.qmd`, has a
   label, a title-case caption, and notes per INV-1; every multi-panel figure uses `fig-subcap` +
   `layout-ncol` with `fig-cap-location: top`.
4. Booktabs only (no `\hline`, no vertical rules), `.rds` exports from scripts (INV-13), no in-figure
   titles (INV-12), section headings carry `{#sec-...}` anchors.

Report a pass/fail list; do not edit unless asked.

### `scaffold [paper/main.qmd]`
Insert the TABLES and FIGURES banner blocks after the `::: {#refs}` div in `main.qmd` (paper-organization
§1), and move any exhibit chunks found in section files into those blocks, leaving the `@tbl-`/`@fig-`
references in the prose. Run `git status` first (co-author awareness) and show the diff before saving.

### `table1`
Build the pre-treatment characteristics table from the project's panel: an R script under `scripts/R/`
computes group means (treated vs. control) by thematic panel plus unit counts, and saves the data frame
as `.rds` under `paper/tables/<script>/`; then add the canonical `kbl()` chunk (paper-organization §2) to
the TABLES block of `main.qmd`. The script is coder work — route it through coder-critic.

### `show`
Print the house-style templates (Table 1 chunk, table chunk rules, multi-panel figure chunk, end-block
layout) from the rule for quick copy-paste.

## Authority

The full specification lives in `.claude/rules/paper-organization.md`; this skill operationalizes it.
Where the house style and `working-paper-format.md` disagree on exhibit placement, the house style wins.
Table and figure note length follows INV-1/INV-2.
