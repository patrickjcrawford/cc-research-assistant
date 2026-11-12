# Content Invariants

These are non-negotiable. Every agent checks against them. Violations are deductions, not suggestions. Critics cite invariant numbers (e.g., "violates INV-3") in their reports.

---

## Paper

**INV-1.** Every table has notes explaining key variables and the sample — via `threeparttable` + `tablenotes` (traditional) or `talltblr` with `note{}` keys (tabularray). Notes are short (roughly 40–70 words): what the table shows, how to read it, and sample details the table does not print. Data sources and method detail belong in the prose, not the notes; do not repeat what the table body already prints (fixed effects, standard-error type).

**INV-2.** Every figure has a caption explaining what is shown and how to read it — via Quarto's `fig-cap` chunk option or a raw LaTeX `\caption{}`. Captions are short (roughly 40–70 words); data sources and method detail belong in the prose, not the caption.

**INV-3.** No `\hline` — use `\toprule`, `\midrule`, `\bottomrule` (booktabs). No vertical rules.

**INV-4.** Significance stars follow the journal profile. AEA journals: no stars, report standard errors and use confidence intervals. Default: stars with note defining thresholds.

**INV-5.** Abstract is 150 words or fewer.

**INV-6.** JEL codes and keywords present after the abstract.

**INV-7.** Notation is consistent across all sections — the same symbol means the same thing everywhere. Different concepts get different symbols.

**INV-8.** Every causal claim has a corresponding identification section. No causal language in descriptive papers.

**INV-9.** Citations use Quarto citeproc + CSL (configured in `_quarto.yml`). Do not add `biblatex` or `natbib` packages manually — Quarto handles citation rendering.

**INV-10.** Cross-references use Quarto native syntax: `@fig-label`, `@tbl-label`, `@sec-label`. Do not use raw `\ref{}`, `\cref{}`, or `hyperref`/`cleveref` packages — Quarto injects these automatically for PDF output.

**INV-11.** Numbers in text match the tables and figures exactly. No rounding discrepancies, no stale values. Pipeline numbers enter prose as inline code (`` `r x` `` / `` `{python} x` ``), not typed (`.claude/references/writing-practice.md` WP-3).

**INV-12.** No titles inside ggplot/matplotlib figures. Titles go in the Quarto `fig-cap` chunk option or a raw LaTeX `\caption{}`. Panel labels ("Panel A: ...") inside multi-panel figures are fine.

**INV-13.** R/Python/Julia scripts export fitted model objects (or summary-stats data frames) as `.rds` to `paper/tables/` — never rendered `.tex`, and never a script-side call to `etable()`/`modelsummary()`. The paper's `main.qmd` loads the object and calls the styling function (`etable()`, `modelsummary()`, `kableExtra::kbl()`) with the caption, notes, and significance convention applied at render time.

**INV-23.** Exhibits sit **in the text**: each table/figure chunk is placed in the section file where it is discussed, right after the paragraph that first cites it (`@tbl-`/`@fig-`), never collected at the end of the paper. Every exhibit is cited in the prose before it appears; appendix exhibits sit in their appendix sections. Per `.claude/rules/paper-organization.md` §1. *(Fork amendment 2026-11-11; upstream collects exhibits at the end.)*

**INV-24.** When the design has treated and control groups, Table 1 is the pre-treatment characteristics table: two group columns (treated vs. control), grouped into thematic panels, with unit counts as bottom rows — no difference, SD, or p-value column. Otherwise Table 1 is the summary-statistics table. Per `paper-organization.md` §2.

**INV-25.** Every table is one canonical chunk, in the section where it is discussed, that loads an `.rds` and styles it at render time, with a `tbl-` label, a title-case descriptive caption, and notes per INV-1; multi-panel figures use `fig-subcap` + `layout-ncol` with the caption on top. Per `paper-organization.md` §3–4.

## Code

**INV-14.** `set.seed()` (or language equivalent) called exactly once, at the top of the main script, if any stochastic element exists.

**INV-15.** All packages/libraries loaded at the top of the script, before any data loading or computation.

**INV-16.** No absolute paths. All paths relative to project root via `here()` (R), `pathlib.Path` (Python), or `joinpath(@__DIR__, ...)` (Julia).

**INV-17.** No growing vectors/lists in loops. Pre-allocate result containers or use vectorized operations.

**INV-18.** Output files go to the path specified by the Output Organization setting in `CLAUDE.md`.

**INV-19.** No prohibited functions: `setwd()` / `os.chdir()` / `cd()`, `rm(list = ls())`, `install.packages()` in scripts, `attach()` / `detach()`.

## Talk

**INV-20.** Notation in talk matches paper exactly — same symbols, same subscripts, same definitions.

**INV-21.** Every claim on a slide is traceable to the paper. No orphan results or numbers that don't appear in the manuscript.

## Traceability

**INV-22.** Every numerical claim in the manuscript must have an entry in the claim-source map (`quality_reports/claim_source_map_{project}.md`) traceable to a specific script line and output file.

**INV-27.** Citation provenance. In the literature working documents (`annotated_bibliography.md`, `frontier_map.md`, `positioning.md`) and in the claim-source map, every statement attributed to a cited work is marked 🟢 (directly supported by that work) or 🟠 (inference or synthesis across sources). Each 🟢 statement is accompanied by the verbatim supporting passage and its page number. If the passage and page cannot be supplied, the statement is marked `[NOT VERIFIED]` and no citation is attached. A citation may appear in `paper/main.qmd` only if a backing 🟢 entry (passage + page), or a 🔵 *author-attested* entry, exists in the claim-source map; a `[NOT VERIFIED]` claim is never cited in the manuscript. Only the user or a named coauthor assigns 🔵 — never an agent (`.claude/references/citation-practice.md`). The 🟢/🟠 markers and passages live in the working documents and the claim-source map, not in the rendered manuscript prose.

## Understanding

**INV-26.** Every script producing a file in `paper/tables/` or `paper/figures/` has a current explainer in `quality_reports/explainers/` and a passing quiz attempt logged at the script's current fingerprint. Current = the explainer's front-matter fingerprint matches `python3 scripts/explainer_status.py --hash <script>`. See `.claude/rules/understanding.md`. Pass/fail gate at `/submit`, warning at `/write results`, never a score.

---

## How Agents Use This File

| Agent | Checks | Action on Violation |
|-------|--------|-------------------|
| **writer-critic** | INV-1 through INV-13, INV-22, INV-23, INV-24, INV-25, INV-27 | Deduct per scoring rubric |
| **librarian-critic** | INV-27 | Deduct per scoring rubric |
| **coder-critic** | INV-13 through INV-19 | Deduct per scoring rubric |
| **storyteller-critic** | INV-20, INV-21 | Deduct per scoring rubric |
| **verifier** | INV-9, INV-10, INV-14, INV-15, INV-16, INV-19, INV-23, INV-24, INV-25, INV-26, INV-27 | FAIL if present |
| **explainer** | INV-26 | Produces the artifacts the invariant requires |
| **/coherence** (deterministic) | INV-5, INV-7, INV-11, INV-13, INV-24 | Major findings block; minor findings block only under `--strict` |
| **/coherence --deep** finders (reasoning) | INV-7, INV-8, INV-11 | Advisory finding — never blocks |
| **lint hook** | INV-14, INV-15, INV-16, INV-19 | Advisory warning |
