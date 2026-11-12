# CLAUDE.MD -- Empirical Economics Research with Claude Code

**Project:** \[PROJECT NAME\] **Institution:** George Mason University **Field:** Economic History & Political Economy **Branch:** main

------------------------------------------------------------------------

## Core Principles

- **Plan first** -- enter plan mode before non-trivial tasks; save plans to `quality_reports/plans/`
- **Verify after** -- compile and confirm output at the end of every task
- **Single source of truth** -- Paper `paper/main.qmd` (Quarto) is authoritative
- **Quality gates** -- weighted aggregate score; nothing ships below 80/100; see `quality.md`
- **Worker-critic pairs** -- every creator has a paired critic; critics never edit files
- **Auto-memory** -- corrections and preferences are saved automatically via Claude Code's built-in memory system

------------------------------------------------------------------------

## Paper Format

**Quarto** (not LaTeX directly). Main file: `paper/main.qmd`

``` bash
# Compile paper
quarto render paper/main.qmd

# Preview paper (live reload)
quarto preview paper/main.qmd

# Online appendix (separate PDF) | talks | alternate layout | after a pipeline rerun
quarto render paper/appendix.qmd
quarto render paper/talks/slides.qmd --to beamer   # or --to revealjs
quarto render paper/main.qmd --profile [name]      # _quarto-[name].yml
quarto render paper/main.qmd --cache-refresh       # only if knitr cache is on
```

Config: `_quarto.yml` \| Bibliography: `references.bib`

------------------------------------------------------------------------

## Pipeline

Update this section to reflect your project's analysis pipeline. Example:

```         
Python notebooks (scripts/python/) OR R scripts (scripts/R/)
    text/data processing
    --> data/cleaned/

R scripts (scripts/R/) — run in order by scripts/R/run_all.R, each in a fresh R process
    01_build_panel.R  [ACTIVE]*  reads data/raw/...       writes data/cleaned/*.rds, data/cache/panel.rds
    02_analysis.R     [ACTIVE]   reads data/cache/panel   writes paper/tables/02_analysis/, paper/figures/02_analysis/
    old_v1_panel.R    [RETIRED]  superseded by 01 on YYYY-MM-DD — do not run or extend

Quarto
    paper/main.qmd    -->  _output/main.pdf
```

`*` = writes `data/cleaned/` (Article II: confirm first; `PROJECT_DRY_RUN=1` skips those writes).

## Key Variables & Design Decisions

Frozen choices every session must respect; change only with the user.

| Item | Choice / definition | Why / built in |
|------|---------------------|----------------|
| `[outcome]`, `[treatment]` | [definition, unit, timing, sign convention] | `01_build_panel.R` |
| Estimator · Sample · Inference | [e.g., LPM + unit/period FE · filters, window · cluster level] | [reason] |

## Data & Publishing Constraints

| Source | Commit? | In replication package? | Notes |
|--------|---------|-------------------------|-------|
| [dataset] | No (data/raw/) | [Yes / summary only / No] | [license, access terms] |
| [hand-built dataset] | Yes (whitelisted, Article II exception) | Yes | [no upstream source] |

**Files to ignore:** [legacy folders, superseded outputs Claude should not read or edit]

------------------------------------------------------------------------

## Folder Structure

```         
[YOUR-PROJECT]/
├── CLAUDE.md
├── _quarto.yml                  # Quarto configuration
├── references.bib               # Bibliography
├── .claude/                     # Rules, skills, agents, hooks
├── paper/                       # Quarto manuscript (source of truth)
│   ├── main.qmd                 # Primary paper file
│   ├── figures/                 # Generated figures (by-script subdirs)
│   ├── tables/                  # Generated tables (by-script subdirs)
│   ├── sections/                # Section-level .qmd files (optional)
│   ├── preambles/               # LaTeX templates for PDF output
│   ├── talks/                   # Presentation slides (.qmd → Beamer or RevealJS)
│   └── outreach/                # Public-facing writing (op-eds, ProMarket, press)
├── data/
│   ├── raw/                     # Original data (large files gitignored)
│   └── cleaned/                 # Analysis-ready datasets (gitignored)
├── scripts/
│   ├── generate_dashboard.py    # Generates project_dashboard.html
│   ├── python/                  # Python/notebook scripts
│   └── R/                       # R analysis scripts
├── quality_reports/             # Plans, session logs, reviews
├── explorations/                # Research sandbox
└── reference_docs/              # Reference papers and data docs
    ├── my_papers/               # Your own prior work (voice corpus, self-citation source)
    └── supporting/              # Others' papers, data docs, slides
```

------------------------------------------------------------------------

## Quality Thresholds

| Score | Gate       | Applies To                        |
|-------|------------|-----------------------------------|
| 80    | Commit     | Weighted aggregate (blocking)     |
| 90    | PR         | Weighted aggregate (blocking)     |
| 95    | Submission | Aggregate + all components \>= 80 |
| --    | Advisory   | Talks (reported, non-blocking)    |

------------------------------------------------------------------------

## Skills Quick Reference

| Command | What It Does |
|------------------------------|------------------------------------------|
| `/new-project [topic]` | Full pipeline: idea to paper (orchestrated) |
| `/discover [mode] [topic]` | Discovery: interview, literature, data, ideation |
| `/strategize [mode] [question]` | Identification strategy, pre-analysis plan |
| `/analyze [dataset]` | End-to-end data analysis |
| `/write [section]` | Draft paper sections + humanizer pass |
| `/review [file/--flag]` | Quality reviews |
| `/revise [report]` | R&R cycle: classify + route referee comments |
| `/talk [mode] [format]` | Create, audit, or compile presentations |
| `/submit [mode]` | Journal targeting to package to audit to final gate |
| `/checkpoint [--flag]` | Session handoff: memory + SESSION_REPORT + research journal + exploration tree |
| `/explain [script]` | Explainer + quiz on agent-written analysis code (INV-26 gate at `/submit`) |
| `/coherence [--deep]` | Internal-consistency audit: refs, citations, numbers vs. tables, notation |
| `/paper-format [mode]` | Audit/apply the Quarto house style: exhibits in the text, Table 1, chunks (INV-23–25) |
| `python3 scripts/generate_dashboard.py` | Regenerate `project_dashboard.html` from current project state |

**Setup (once per clone):** Claude Code ≥ 2.1.295; a `python3` on PATH (Windows: `uv python install --default`); `bash scripts/install-hooks.sh` for the pre-commit gate; copy `.Rprofile.example` → `.Rprofile` (never commit); project Python via `uv run python`. R path if `Rscript` is not on PATH: `[C:/Program Files/R/R-x.y.z/bin/Rscript.exe]`. On Windows read `.claude/references/windows-environment.md`.

------------------------------------------------------------------------

## Beamer Custom Environments (Talks)

| Environment  | Effect          | Use Case        |
|--------------|-----------------|-----------------|
| `[your-env]` | \[Description\] | \[When to use\] |

------------------------------------------------------------------------

## Output Organization

Output organization: by-script

------------------------------------------------------------------------

## Current Project State

| Component   | File                 | Status      | Description              |
|-------------|----------------------|-------------|--------------------------|
| Paper       | `paper/main.qmd`     | not started | \[Brief description\]    |
| Data        | `scripts/R/`         | not started | \[Analysis description\] |
| Replication | `paper/replication/` | not started | --                       |