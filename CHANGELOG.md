# Changelog

All notable changes to this template are documented here.

**Versioning:** CalVer (YY.MM). Git commits provide granularity within a release.

------------------------------------------------------------------------

## [Fork] — Unreleased

Changes in this fork (cc-research-assistant) not in upstream clo-author.

### Lessons from three dissertation projects (2026-11-11)

About 100 corrections recorded while writing three economic-history papers with this template, triaged
and generalized. Plan: `quality_reports/plans/2026-11-11_upstream-and-dissertation-learnings.md`.

- **Bugs fixed.**
  - Section headings: the template prescribed `## Section`, which makes the `abstract-section` filter render the whole paper inside the abstract. Sections are now level-1 `#`.
  - Beamer: the format never loaded `slides-header.tex`; a talk scaffold pointed to a preamble that doesn't exist.
  - `/tools compile` called `latexmk` and a `latexmkrc` that doesn't exist; it now uses Quarto.
  - Table guidance contradicted INV-1 (SE type and star thresholds repeated in notes); the examples used `\label{}` and `hold_position`.
  - Smaller fixes: a stale `Bibliography_base.bib` gotcha, a tracked `.pyc`, and data gitignore lines that were commented out contrary to Article II.
- **New fork-only references** (agents get one-line pointers, so upstream merges stay small):
  - `empirical-practice.md`: no specification search, check the event-time sign, family-wise re-tests, estimator p-values, strip data from saved fixest fits.
  - `writing-practice.md`: verdict words for significance in prose, inline-code numbers, never narrate the build.
  - `citation-practice.md`: passage direction, original-language sources, 🔵 author-attested.
  - Also `quarto-gotchas.md`, `windows-environment.md`, `text-as-data.md`, `working-practices.md` and `outreach-style.md`.
- **Rules.**
  - INV-11: pipeline numbers enter prose as inline code.
  - INV-27: 🔵 author-attested, assigned by the user only.
  - Article II (**constitutional amendment**): hand-built datasets may be committed when whitelisted; corrections to raw data go through a paste-ready CSV.
  - Float placement is `"!t"`, or `"p"` for page-sized exhibits; never `H`/`h`.
  - Citation keys are Zotero's Better BibTeX keys (`authorYear2keywords`).
  - Event-study zero line faint and solid, reference period dotted.
  - Critic rounds past three are allowed when the remaining items are mechanical.
- **Scaffold.**
  - Quarto config: link colours, `date: today`, `threeparttablex`.
  - New files: a RevealJS theme, `.Rprofile.example`, `pyproject.toml`, R pipeline templates (`_paths.R`, `_cache.R`, `run_all.R` with `PROJECT_DRY_RUN`), and economic-history journal profiles (JEH, EEH, EHR, EREH, Cliometrica).
  - New CLAUDE.md sections: Key Variables & Design Decisions, and Data & Publishing Constraints.
- **Features.**
  - `/tools sync-template` (template → project).
  - `/write outreach`, which asks for the output format first.
  - Alternate-layout Quarto profiles (`templates/quarto-profile/`).
  - Claim-margin review PDF: `paper/claim-margin.lua` and `scripts/claim_comments.py`.

- Added optional Zotero MCP integration: Librarian, Explorer, and their paired critics can now consult a connected `zotero-mcp` server as a supplementary search/verification method alongside their existing web-based search. Read-only for critics and Explorer; Librarian additionally gets user-gated add-to-library tools. See `.claude/references/zotero-search-protocol.md`. Also fixed a stale `mcp__zotero__*` tool-prefix reference in the `/discover` skill (correct prefix is `mcp__zotero-mcp__*`).
## [26.09] — September 2026

Rebuilt for Opus 5.5 and current Claude Code. Scripts now enforce the gates, so the model no longer does that arithmetic. Hooks that had been failing silently now run, and say so when they break. Rules state goals instead of steps, and load only when relevant. This release also includes the June–August work: the paper house style, `/coherence`, `/deepread`, and `/explain`. Requires Claude Code 2.1.295 or later.

### Scripts enforce the gates

- **`scripts/score.py`** computes the weighted aggregate, renormalizes over scored components, maps strategist verdicts to points, and evaluates the commit (80), PR (90), and submission gates. Submission needs 95, every component ≥ 80, and the understanding gate. `quality-gates.json` is the single source for the numbers. On a new project with nothing scored yet, the commit gate passes with a notice.
- **`scripts/pipeline.py`** checks each agent's REQUIRES/PRODUCES from `permissions.md` before and after dispatch. It derives `pipeline_state.json` from the research journal and flags HIGH-PERF / FRICTION / escalation traces.
- **`scripts/verify.py`** runs the verifier's mechanical checks: compile, file integrity, freshness, script inventory, dependencies, master run, exhibit cross-reference, and INV-26. Exhibits are traced to scripts under either Output Organization layout.
- **`scripts/paper_coherence.py`** (INV-5 abstract length, INV-24 Table 1 columns), **`scripts/style_metrics.py`** (the writer-critic's countable deductions), and **`scripts/check_scaffold.py`** (broken references, missing hook files, weight disagreements, malformed frontmatter, the always-loaded budget).
- **Pre-commit gate** (`scripts/install-hooks.sh`, once per clone): blocks on scaffold errors, failing hook or script tests, and HIGH lint findings in staged scripts. Bypass with `SKIP_GATE=1`.

### Hooks that run, and fail loudly

- `post-edit-lint` read an environment variable Claude Code never sets, and `post-compact-restore` checked `type` instead of `source`. Both had been dead for months. Both now work: lint findings reach Claude as `additionalContext`, and context is restored after compaction and resume.
- Every hook runs through `.claude/hooks/_hooklib.py`. Each run ends as acted, skipped, or error, is logged to `.claude/state/hook-log.jsonl`, and a missing payload field is an error rather than a silent skip. `hook-health.py` reports dead or erroring hooks at session start. `scripts/test_hooks.py` covers all of them.
- **Guards fail closed.** `protect-files` and `session-guard` set `"onFailure": "block"`. A guard that crashes now blocks the call; before, it let the call through.

### Consistent, lighter rules

- **Contradictions resolved.** `paper-organization.md` is the single source for Table 1, wrappers, and section order. Submission is 95 everywhere. strategist-critic now gives a verdict, and SOUND or MINOR ISSUES lets execution start. The 120% weight sum with theory is explained. No rule names a nonexistent agent.
- **Path-scoped rules.** Paper, revision, and pipeline rules load when matching files are read. Instructions loaded every session dropped from 1,817 to 679 lines.
- The LaTeX preamble moved to `paper/preambles/header.tex`. The `html-dashboard.md` rule is gone; `/dashboard` runs `generate_dashboard.py`.

### Written for current models

- **Plan mode** gates multi-agent pipeline runs and many-file changes, not every non-trivial task. `/new-project` keeps it.
- **PDFs** are read directly with page ranges; the 5-page chunking protocol is gone.
- **Effort per agent:** `high` for strategist, theorist, their critics, methods-referee, and editor; `low` for the narrow checkers. `model: inherit` everywhere.
- `/deepread` and `/new-project` run only when you type them. The orchestrator can dispatch only registry agents. `/review --peer` round 1 gives referees a fenced copy of the manuscript.

### New skills and agents (June–September)

- **`/paper-format`** applies the mandatory paper house style (INV-23/24/25): floats at the end, Table 1 as pre-treatment characteristics, and canonical wrappers.
- **`/coherence`** audits a paper's internal consistency. Layer 1 is a deterministic parser; `--deep` adds reasoning finders (one `coherence-finder` definition, run per check group) with a batched `coherence-skeptic`.
- **`/deepread`** runs a deep technical read on Codex at no Claude token cost. Its prompts live in `scripts/deepread_prompts/`.
- **`/explain`** checks that you understand agent-written analysis code: an explainer, a 5-question quiz, and the INV-26 understanding gate at `/submit`.
- **`/dashboard`** gains a pipeline section and no longer overwrites hand-written sections.
- Roster: 25 agents, 18 skills.

### Also

- MIT `LICENSE` with fork attribution. Personal permissions moved to the gitignored `settings.local.json`, plus a deny list (push to upstream, force push, hard reset, `rm -rf`).
- Fixed `/deepread`'s frontmatter, which left its description empty. `check_scaffold.py` now catches that shape.
- **`/tools upgrade`** now carries the scaffold scripts (files marked `clo-author: infrastructure`), `.githooks/`, and a missing preamble. It moves your `settings.json` additions into `settings.local.json` instead of restoring the old file over the new hooks.
- `/freeze` and `/careful` were documented as resetting when the conversation ends. They actually stay on until you turn them off, and the docs now say so.

---

## [26.05] — May 2026

<!-- Add new entries above this line -->
