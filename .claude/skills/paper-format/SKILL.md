---
name: paper-format
description: Apply and enforce the paper house style in Quarto — exhibits in the text (each chunk in the section that discusses it, after its first citation), Table 1 pre-treatment characteristics, canonical table/figure chunks, section order, captions. Use when building, formatting, or auditing a paper's tables, figures, or structure. Enforces INV-23/24/25.
argument-hint: "[mode: audit | scaffold | table1 | show | end-exhibits] [target file]"
allowed-tools: Read,Grep,Glob,Write,Edit,Bash
---

# Paper Format (House Style)

Applies and enforces `.claude/rules/paper-organization.md` (blocking invariants **INV-23, INV-24,
INV-25**) on this fork's Quarto manuscript: `paper/main.qmd` plus `paper/sections/*.qmd`.

**Input:** `$ARGUMENTS` — a mode and optional target. Default mode: `audit`.

## Modes

### `audit [paper/main.qmd]` (default)
Check the paper against the house style and report violations with invariant numbers:
1. **INV-23 — exhibits in the text.** For every `#| label: (tbl|fig)-` chunk, `{#fig-` image, and
   `{=latex}` table/figure block in `main.qmd` and `paper/sections/*.qmd`:
   - it sits in the section file that discusses it — a chunk after the `::: {#refs}` div or in an
     end-of-paper TABLES/FIGURES block is a violation;
   - its first `@tbl-`/`@fig-` citation comes *before* it, in the same section (or an earlier one);
   - it follows the paragraph of that first citation, not several paragraphs later;
   - an exhibit never cited in the prose is a violation.
2. **INV-24 — Table 1.** If the design has treated and control groups, confirm the first table is
   pre-treatment characteristics: two group columns, thematic panels, unit counts at the bottom, and
   **no difference / SD / p-value column**. Otherwise confirm it is the summary-statistics table.
3. **INV-25 — canonical chunks.** Every table chunk loads an `.rds` and styles it at render time, has a
   label, a title-case caption, and notes per INV-1; every multi-panel figure uses `fig-subcap` +
   `layout-ncol` with `fig-cap-location: top`.
4. Booktabs only (no `\hline`, no vertical rules), `.rds` exports from scripts (INV-13), no in-figure
   titles (INV-12), section headings carry `{#sec-...}` anchors.

Report a pass/fail list; do not edit unless asked.

### `scaffold [paper/main.qmd]`
Place exhibits in the text (paper-organization §1): move each chunk found in an end-of-paper block of
`main.qmd` (or far from its discussion) into the section file that first cites it, directly after the
citing paragraph; make sure `main.qmd` has a setup chunk that loads the packages those chunks use.
Run `git status` first (co-author awareness) and show the diff before saving.

### `end-exhibits` (submission only, on request)
For a journal that requires tables and figures at the end of the manuscript: on a branch, move every
exhibit chunk into TABLES/FIGURES blocks after the references div, leaving the `@tbl-`/`@fig-`
citations in place. Never the default; the working paper keeps exhibits in the text.

### `table1`
Build the pre-treatment characteristics table from the project's panel: an R script under `scripts/R/`
computes group means (treated vs. control) by thematic panel plus unit counts, and saves the data frame
as `.rds` under `paper/tables/<script>/`; then add the canonical `kbl()` chunk (paper-organization §2) to
the Data section, right after the paragraph that first cites it. The script is coder work — route it
through coder-critic.

### `show`
Print the house-style templates (Table 1 chunk, table chunk rules, multi-panel figure chunk, in-text
placement layout) from the rule for quick copy-paste.

## Authority

The full specification lives in `.claude/rules/paper-organization.md`; this skill operationalizes it.
Where the house style and `working-paper-format.md` disagree on exhibit placement, the house style wins.
Table and figure note length follows INV-1/INV-2.
