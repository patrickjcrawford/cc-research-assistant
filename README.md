# cc-research-assistant

Patrick Crawford's personal fork of [hugosantanna/clo-author](https://github.com/hugosantanna/clo-author) — a Claude Code scaffold for empirical economics research.

Customized for:
- **Quarto** paper format (not LaTeX directly)
- **George Mason University / Department of Economics**
- **Economic history & political economy** projects
- R + Python analysis pipeline
- By-script output organization

## To start a new project

```bash
gh repo fork patrickjcrawford/cc-research-assistant --clone --fork-name [your-project-name]
cd [your-project-name]
claude
```

Then fill in the `[BRACKETED PLACEHOLDERS]` in `CLAUDE.md` and `_quarto.yml`, and tell Claude:

```
I am starting a research project on [YOUR TOPIC]. Read CLAUDE.md and help me set up.
```

## Upstream

To pull template updates from Hugo's original:

```bash
git fetch upstream
git merge upstream/main
```

## Running the Pipeline: Full vs. Step-by-Step

### Full run
```
/new-project [topic]
```
The only skill that's always orchestrated — it dispatches every phase below automatically, worker paired with critic, and won't advance a phase whose gate isn't met. Use this when you're starting from a bare idea and want Claude driving.

### Step-by-step
Every phase can also be invoked directly, skipping ahead or re-entering mid-pipeline, as long as its `REQUIRES` (declared in `.claude/rules/permissions.md`) is already satisfied. This is the normal mode once a project is underway — most sessions touch one phase, not the whole pipeline.

| Order | Skill | Dispatches | Requires | Produces |
|-------|-------|-----------|----------|----------|
| 1 | `/discover lit` | librarian → librarian-critic | Research idea | `quality_reports/literature/{project}/` |
| 1 | `/discover data` | explorer → explorer-critic | Research idea | `quality_reports/data-assessment/{project}/` |
| 2 | `/strategize` | strategist → strategist-critic | Literature OR data assessment | `quality_reports/strategy/{project}/strategy_memo.md` |
| 2 | `/strategize theory` | theorist → theorist-critic | Strategy memo (theory-bearing papers only) | `quality_reports/theory/{project}/` |
| 3 | `/analyze` | data-engineer + coder → coder-critic | strategist-critic score ≥ 80 | `data/cleaned/`, `paper/tables/*.rds`, `paper/figures/`, `quality_reports/results_summary.md` |
| 4 | `/write` | writer → writer-critic | coder-critic score ≥ 80, `paper/tables/` has `.rds` files | `paper/main.qmd`, `quality_reports/claim_source_map_{project}.md` |
| 5 | `/review` | editor + domain-referee + methods-referee | writer-critic score ≥ 80, coder-critic score ≥ 80 | `quality_reports/reviews/editorial_decision.md` |
| — | `/talk` | storyteller → storyteller-critic | writer-critic score ≥ 80 (can run parallel with `/review`) | `paper/talks/` |
| 6 | `/submit` | verifier | overall score ≥ 95, all components ≥ 80 | `quality_reports/verification_report.md` |
| any time | `/revise [report]` | routes to coder, writer, or you, per comment | a real referee report | Updated paper + response letter |

Rows sharing an order number (1, or 2) are the same `PARALLEL_GROUP` in `permissions.md` — dispatchable concurrently once their shared prerequisite is met.

**Entering mid-pipeline:** if you already have data and a draft, you can invoke `/strategize` or even `/review` directly — Claude checks `REQUIRES`, not phase numbers. A referee comment needing new analysis routes back to `/analyze` → `/write` → `/review`, not a full restart.

**"Just do it" mode:** appending that phrase to any request skips the final approval pause and auto-commits if the score gate passes — the worker-critic loop and verification still run.

See `.claude/rules/workflow.md` (orchestrator loop, dependency graph) and `.claude/rules/permissions.md` (per-agent REQUIRES/PRODUCES/escalation) for the full mechanics.

## Folder Structure

Every folder below is scaffolded with a `.gitkeep` so forks start with the full layout. Git-tracked status is the default from `.gitignore`; downstream projects uncomment the ignore blocks noted below once real data/output starts flowing in.

### `.claude/` — the agent system (git: tracked)
Rules, agents, skills, and hooks that define how Claude behaves in this repo. You edit this when you want to change *how Claude works*, not the paper itself.
- `agents/` — one file per worker or critic agent (writer, coder, strategist, etc.)
- `rules/` — cross-cutting policy: quality gates, invariants, workflow, permissions registry
- `skills/` — slash-command implementations (`/analyze`, `/write`, `/review`, ...)
- `references/` — coding standards (R/Python/Julia), domain profile, journal profiles, personal style guide
- `hooks/` — shell/Python scripts that run on Claude Code lifecycle events (lint on save, protect files, etc.)
- `state/` — machine-local config (e.g. `obsidian-config.md`). Gitignored except `*.example` files — never share real paths or tokens here.
- `settings.local.json` — your personal permission overrides. Gitignored; `settings.json` (shared defaults) is tracked.

**You interact with this directory** by editing rules/skills when you want to change workflow conventions (as we just did for the table pipeline), or by reading it when you want to understand why Claude did something a certain way.
**Claude reads this directory** on every turn — it's the constitution. Claude should rarely write here unless you explicitly ask for a rule/skill change.

### `paper/` — the manuscript (git: tracked, except compiled outputs)
Source of truth per `CLAUDE.md` Article I. Everything downstream (PDF, talks, outreach pieces) derives from `main.qmd` plus the scripts.
- `main.qmd` — the paper. Single file unless you split into `sections/`.
- `appendix.qmd` — a standalone companion document, **not** included from `main.qmd` — compiles to its own PDF (`quarto render paper/appendix.qmd`) with its own title page (large "Appendix" banner plus the same project metadata as `main.qmd`) for online/published appendices. Its content sections live in `sections/` alongside the main paper's, prefixed `app-` (`app-tables.qmd`, `app-figures.qmd`, `app-robustness.qmd`), and are pulled in via `{{< include >}}`.
- `sections/` — optional per-section `.qmd` files, included from `main.qmd`; files prefixed `app-` are `appendix.qmd`'s subsections instead
- `figures/` — `.pdf`/`.png` figures generated by `scripts/R/` or `scripts/python/`. Tracked (they're small, reviewable outputs) — reproducible from scripts, so treat them as regeneratable rather than hand-edited.
- `tables/` — **`.rds` model objects and summary-stats data frames**, one per table, saved by the analysis scripts. Not rendered LaTeX. `main.qmd` loads each `.rds` and calls `etable()`/`modelsummary()`/`kableExtra` to style and render it at compile time (see `.claude/rules/working-paper-format.md` and INV-13).
- `preambles/` — LaTeX preamble snippets for PDF output (article vs. Beamer)
- `talks/` — presentation `.qmd` files (Beamer or Quarto RevealJS), produced by `/talk`
- `outreach/` — public-facing writing (op-eds, ProMarket pieces, press) — not part of the academic paper's Article I lineage
- `replication/` — the AEA-style replication package assembled at submission time

**You interact with this directory** by reading/editing `main.qmd` prose directly, and by reviewing rendered tables/figures.
**Claude interacts with this directory** via the writer (drafts `.qmd` prose, never touches `tables/`/`figures/` contents directly) and the coder/data-engineer (write `tables/*.rds` and `figures/*.pdf`, never touch `.qmd` prose).

### `scripts/` — the analysis (git: tracked; scripts only, not their outputs)
Authoritative per `CLAUDE.md` Article I — numbers in the paper are only ever right if they trace back here.
- `R/`, `python/` — numbered pipeline scripts (`01_build_panel.R`, `02_estimation.R`, ...) plus a `functions/` subfolder for reusable helpers
- `generate_dashboard.py` — regenerates `project_dashboard.html` from current project state

**You interact with this directory** by writing/reviewing analysis code, and by running scripts yourself when you want to check something outside the agent loop.
**Claude interacts with this directory** via the coder and data-engineer agents, which write scripts here and are the only agents allowed to modify `data/cleaned/` as a side effect of running them (with your confirmation per Article II).

### `data/` — raw and cleaned datasets (git: **ignored**)
Per `CLAUDE.md` Article II, raw data never enters git and cleaned data is regenerable from scripts, so neither is committed — only the `.gitkeep` placeholders are tracked to preserve the folder in a fresh clone.
- `raw/` — original data exactly as obtained. Claude never deletes or overwrites files here, regardless of instruction (Article II) — if a raw file needs replacing, you do it manually.
- `cleaned/` — analysis-ready datasets produced by `scripts/R/`. Any script that writes here requires your explicit confirmation before each run, even if you say "just do it."

**You interact with this directory** by dropping in raw source files and by spot-checking cleaned output.
**Claude interacts with this directory** only through scripts in `scripts/`, and only after describing what will be overwritten.

### `quality_reports/` — pipeline artifacts and agent output (git: tracked)
Where every worker-critic pair leaves its paper trail — plans, memos, scores, the research journal, pipeline state.
- `plans/` — saved plans from Plan Mode (`YYYY-MM-DD_description.md`)
- `specs/` — requirements specs for ambiguous/complex tasks
- `literature/`, `data-assessment/`, `strategy/`, `theory/` — Discovery/Strategy phase artifacts (annotated bibliography, data feasibility, strategy memo, formal theory)
- `reviews/` — critic and referee reports
- `traces/` — execution traces + cross-session pattern analysis
- `results_summary.md` — the Coder's plain-language summary of every number that will appear in the paper. This is the Writer's only source of numbers now that tables are `.rds` objects it can't parse directly — see `.claude/agents/writer.md`.
- `research_journal.md`, `pipeline_state.json` — narrative log and machine-readable state, read on every session recovery

**You interact with this directory** mostly by reading it to understand what Claude has concluded at each phase; you rarely write here directly.
**Claude interacts with this directory** constantly — every agent invocation logs here, and the orchestrator reads it to decide what's dispatchable next.

### `explorations/` — sandbox (git: tracked, but treat as disposable)
Scratch work that skips the plan-first requirement (Article IV exception) and the co-author-safety check (Article V exception). Use for one-off checks you don't want gating the main pipeline.

### `reference_docs/` — source material Claude reads but never writes (git: tracked)
- `my_papers/` — your own prior publications, used as the voice corpus for `/write style-guide`
- `supporting/` — others' papers, data documentation, slides you want Claude to consult

**You interact with this directory** by dropping in PDFs/docs.
**Claude interacts with this directory** read-only, for style calibration or background context — never edits or deletes source material here.

### Root files
- `CLAUDE.md` — project configuration: institution, field, pipeline description, current state table. Edit this whenever the project's shape changes.
- `_quarto.yml` — Quarto project config (PDF engine, bibliography, CSL). Edit for format-level changes (e.g. disabling double-spacing for a handout).
- `references.bib` — bibliography, tracked in git.
- `SESSION_REPORT.md` — append-only session log (`/checkpoint` writes here).
- `CHANGELOG.md` — template-level change history (for the public-template side of this repo, see `.claude/rules/meta-governance.md`).

### Always ignored, regardless of project
`.claude/settings.local.json`, `.claude/state/*` (except `*.example`), `.quarto/` (Quarto's language-server cache), OS/editor noise (`.DS_Store`, `*.swp`). Everything else in `.gitignore` is commented out in the template and meant to be uncommented per-project once you start generating LaTeX build artifacts, compiled PDFs, and real data files — see the file itself for the specific blocks (LaTeX aux files, `data/cleaned/*.rds`, `data/raw/**/*.csv`, etc.).

## Table Pipeline

Tables follow a two-step handoff (INV-13, `.claude/rules/working-paper-format.md`):

1. **Script side** (`scripts/R/`): fit the models, save the fitted objects as `.rds` to `paper/tables/`. No `etable()`/`modelsummary()` call, no rendered LaTeX.
2. **Paper side** (`paper/main.qmd`): a chunk loads the `.rds` and calls `etable()`/`modelsummary()` with the caption, notes, and significance-star convention applied at render time.

This means restyling a table (switching to an AEA no-stars format, renaming a coefficient, editing a note) is a one-line change in the qmd — it never requires re-running estimation. `paper/tables/` still exists as the handoff point between the two steps; it just holds model objects instead of pre-rendered `.tex` fragments now.
