# Quarto Gotchas — Render Failures That Do Not Raise Errors

Fork-owned reference. Read by the writer, coder, verifier, and storyteller. Every item here rendered
"successfully" while producing a wrong document. `working-paper-format.md` and `paper-organization.md`
hold the rules; this file holds the traps.

---

## A clean exit code is not a correct document

After `quarto render`, also check the output itself:

```bash
pdftotext -layout _output/paper/main.pdf - | grep -nE '^#{1,3} |\\begin\{tabular|\?@(tbl|fig|sec)-|\[WARNING'
```

- Leaked `## Heading` text means a heading lacks a blank line before it — sweep one section file at a
  time, don't trust a single grep of the source.
- Leaked `\begin{tabular}` means an `etable()`/`kbl()`/`cat()` chunk is missing `#| output: asis`.
- Confirm section numbers appear, and every table and figure has a number.
- `-M latex-clean:false` keeps the `.log`; grep it for `Overfull \hbox` (notes or tables too wide).

## Tables and cross-references

- Cross-reference a table through the chunk's `#| label: tbl-...` + `#| tbl-cap:`. Never wrap the chunk
  in a `::: {#tbl-...}` div and never add a raw `\label{}` — both break `@tbl-` resolution.
- kableExtra in `asis` output: style note titles with `footnote(title_format = "italic")`, not a bare
  `\textit{}` string, which loses its backslash.
- Table notes passed to `etable(notes=)` are one string; a multi-element vector renders as separate
  lines or breaks the threeparttable.
- A YAML caption written as `!expr` must be single-quoted (`tbl-cap: !expr 'paste0(...)'`); an unquoted
  `Notes: ...` breaks YAML parsing.
- Never `H`/`h`/`hold_position` placement (`paper-organization.md` §1).

## Caching serves stale numbers silently

- With `cache: true` (or `freeze: auto` on project renders), a chunk that only calls `readRDS()` keeps
  its old result after the pipeline reruns. Either render with `--cache-refresh`, or make the cache
  depend on the file:
  `#| cache.extra: !expr tools::md5sum(here::here("paper/tables/03_main/reg_main.rds"))`
- After any rerun, spot-check one inline number and one table against `results_summary.md`.
- Talks: chunks with `cache: true` keep old coefficient labels after a `setFixest_dict()` change — use
  `--cache-refresh`. `*_cache/` and `*_files/` folders are gitignored.

## Headings and the abstract

- `main.qmd` uses the `abstract-section` filter: everything after `# Abstract` up to the next **level-1**
  heading becomes the abstract. Sections must therefore be `# Title {#sec-name}`; a paper written with
  `##` sections renders entirely inside the abstract, as `\subsection`s, without any error.
- Content moved into the abstract is metadata, so body filters (e.g. `claim-margin.lua`) do not see it.

## YAML metadata

- In a document's YAML, an `author:` **array** replaces the `_quarto.yml` author list, but a scalar
  `author: "Name"` is **appended** to it. Outreach pieces, solo talks, and appendices use the array form.
- Paths in `_quarto.yml` resolve from the project root; paths in a document's YAML resolve from the
  document (`paper/talks/x.qmd` reaches the preamble as `../preambles/...`).
- `quarto render paper/x.qmd` with project formats `pdf` and `beamer` defined: talks pass `--to beamer`
  / `--to revealjs` explicitly.

## Profiles and kept tex

- `/coherence` and `scripts/verify.py` audit the kept `paper/main.tex`. Quarto always writes the kept tex
  as `paper/main.tex` whatever `output-file` says, so an alternate-layout profile render overwrites it —
  see `working-paper-format.md` § Alternate layouts for the pre/post-render guard.

## Source conventions

- Em dashes `---` and en dashes `--` in `.qmd`, not Unicode characters, so the source diff stays readable
  and LaTeX ligatures are consistent.
- Preamble `.tex` partials must be multi-line: on one line, the first `%` comments out the rest silently.
