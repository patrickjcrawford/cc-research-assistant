---
name: tools
description: Utility commands — commit, compile, validate-bib, lint, journal, context-status, deploy, learn, upgrade (from clo-author), sync-template (template → this project).
argument-hint: "[subcommand: commit | compile | validate-bib | lint | journal | context | dashboard | deploy | learn | upgrade | sync-template] [args]"
allowed-tools: Read,Grep,Glob,Write,Edit,Bash,Agent,Task
---

# Tools

Utility subcommands for project maintenance and infrastructure.

**Input:** `$ARGUMENTS` — subcommand followed by any arguments.

---

## Subcommands

### `/tools dashboard [--open]` — Project Dashboard
Regenerate the project dashboard HTML file.

```bash
python3 scripts/generate_dashboard.py
```

If `--open` is specified (or by default), open the dashboard in the browser:
```bash
open project_dashboard.html
```

The dashboard scans the entire project — paper sections, data, scripts, quality reports, bibliography, plans — and renders an interactive HTML overview. Regenerate it after any significant work.

### `/tools commit [message]` — Git Commit
Stage changes, create commit, optionally create PR and merge.
- Run git status to identify changes
- Stage relevant files (never stage .env or credentials)
- Run `python3 scripts/score.py --gate commit`. If it fails, stop and report which components pull
  the score below 80. On a project nothing has scored yet it passes with a notice; say so and commit.
- Create commit with descriptive message; note the score when there is one
- The git pre-commit hook (`scripts/install-hooks.sh` installs it) runs scaffold integrity and lint
  checks on every commit, including ones made outside this skill

### `/tools compile [file]` — Quarto Render
Everything renders through Quarto, which runs all LaTeX passes itself (`working-paper-format.md`).
Never call `latexmk`, `xelatex`, or `biber` directly.

```bash
quarto render paper/main.qmd                          # paper
quarto render paper/appendix.qmd                      # online appendix (separate PDF)
quarto render paper/talks/[file].qmd --to beamer      # talk, Beamer PDF
quarto render paper/talks/[file].qmd --to revealjs    # talk, HTML deck
quarto render paper/main.qmd --profile [name]         # alternate layout (_quarto-[name].yml)
quarto render paper/main.qmd --cache-refresh          # after a pipeline rerun when knitr cache is on
```

After rendering, check the exit code, `?@` unresolved references and `[WARNING] Citeproc` lines,
and `Overfull \hbox` in the log (`-M latex-clean:false` keeps it).

### `/tools validate-bib` — Bibliography Validation
Cross-reference all `\cite{}` / `@` keys in paper and talk files against `references.bib`.
Report: missing entries, unused entries, duplicate keys.

### `/tools lint [file|dir]` — Mechanical Code Linting
Run grep-based checks on R/Python/Julia scripts against the coding standards' prohibited patterns. Catches mechanical violations before the coder-critic's judgment review.

```bash
"$CLAUDE_PROJECT_DIR"/.claude/hooks/lint-scripts.sh [target]
```

- **Single file:** `/tools lint scripts/02_estimate.R`
- **Directory:** `/tools lint scripts/` (recursive)
- **Default:** `/tools lint` (lints `scripts/`)

**What it checks (drawn from `.claude/references/coding-standards-*.md`):**

| Check | R | Python | Julia | Severity |
|-------|---|--------|-------|----------|
| Absolute paths | x | x | x | HIGH |
| `setwd()` / `os.chdir()` / `cd()` | x | x | x | HIGH |
| Missing seed (stochastic code) | x | x | x | HIGH |
| `install.packages()` / `pip install` | x | x | | HIGH |
| `rm(list = ls())` | x | | | MEDIUM |
| `T`/`F` literals | x | | | MEDIUM |
| `sapply()` | x | | | MEDIUM |
| `attach()`/`detach()` | x | | | MEDIUM |
| `<<-` global assignment | x | | | MEDIUM |
| `stargazer` / `plyr` | x | | | MEDIUM |
| `set.seed()` position (after line 30) | x | | | MEDIUM |
| Wildcard imports | | x | | MEDIUM |
| `np.random.seed()` global state | | x | | MEDIUM |
| Bare `except:` | | x | | MEDIUM |
| `eval`/`@eval` runtime | | | x | MEDIUM |
| Late `library()`/`import`/`using` | x | x | x | LOW |
| `print()` for status | x | | | LOW |
| `require()` | x | | | LOW |
| `1:n` patterns | x | | | LOW |

**Output:** Findings by file with severity, line number, and fix suggestion. Always advisory (exit 0).

**When to use:**
- Before `/review --code` — catches mechanical violations instantly
- Before commits — quick sanity check
- The coder-critic focuses on judgment (strategy alignment, numerical plausibility, design); this catches the grep-able stuff

### `/tools journal` — Research Journal
Regenerate the research journal timeline from quality reports and git history.
Shows chronological record of agent actions, phase transitions, scores, decisions.

### `/tools context` — Context Status
Show current context status and session health.
Check context usage, whether auto-compact is approaching, what state will be preserved.

### `/tools learn` — Extract Learnings
Extract reusable knowledge from the current session. Auto-memory handles corrections automatically; this is for multi-step workflows worth turning into a full skill.

### `/tools upgrade` — Pull a New Upstream Release
Merge a new clo-author release into this fork.

This fork is Quarto-based and diverges from upstream (LaTeX) by design, so **upstream's
delete-and-replace `.claude/` procedure does not apply here**: it would wipe the Quarto rules,
prose-critic, citation provenance (INV-27), the exploration tree, and the Zotero protocol. The
upstream release is tracked as a git ancestor (each sync ends with a `-s ours` merge of the release
tag), so a normal merge finds the right base. Show the user this plan and wait for approval.

```
Step 1: PREPARE
  - git status clean on main; git fetch upstream --tags
  - read the release's CHANGELOG.md entries since the last synced tag
  - git switch -c upgrade/<tag>

Step 2: MERGE
  - git merge <tag>   (the release tag, not upstream/main, so the sync point is exact)
  - resolve conflicts by .claude/sync-manifest.md: TEMPLATE files take upstream logic but keep
    fork additions; PROJECT files keep ours; MERGE files by hand
  - LaTeX-only upstream changes (main.tex, latexmkrc, header.tex, \cref, biblatex) are translated
    to Quarto or excluded — never taken as-is. Excluded paths are listed in sync-manifest.md
  - scripts marked "clo-author: infrastructure-fork" carry Quarto patches: re-apply them on top of
    upstream's new version

Step 3: VERIFY AND REPORT
  - python3 scripts/check_scaffold.py, scripts/test_hooks.py, scripts/test_scripts.py pass
  - quarto render paper/main.qmd still renders
  - list what changed, what was translated or excluded, and any judgment calls left for the user
  - nothing merges to main or pushes without the user's review
```

### `/tools sync-template [--init <url-or-path> | --apply]` — Pull Template Updates into a Project
Run inside a research project spawned from this template (not in the template itself). Labels come
from the project's copy of `.claude/sync-manifest.md` — after the first sync, from the template's.

```
--init <url-or-path>   once per project (also done by /new-project)
  - git remote add template <url-or-path>; git fetch template
  - create .claude/template-sync.log with a header line

(no flag) STATUS — read-only
  - git status + git log --oneline -5 (Article V: flag uncommitted work in files a sync would touch)
  - git fetch template
  - git diff --name-status HEAD template/main -- .claude templates scripts/*.py scripts/*.sh
      .githooks paper/preambles paper/outreach/_outreach-scaffold.qmd _extensions
      .gitignore .Rprofile.example CLAUDE.md
  - classify every path by sync-manifest label and print three lists:
      TAKE    (TEMPLATE: overwrite)      incl. files deleted in the template (e.g. retired hooks)
      REVIEW  (MERGE: hand-merge)        CLAUDE.md, settings.json, .gitignore, fork-patched scripts
      SKIP    (PROJECT: never touched)   domain/journal profiles, style guide, settings.local.json
  - show the last line of .claude/template-sync.log (what the project last aligned to)
  - stop; wait for the user to approve the lists

--apply  (after approval)
  - git switch -c template-sync/YYYY-MM-DD
  - TAKE:   git checkout template/main -- <paths>;  git rm <paths deleted in the template>
  - REVIEW: git diff HEAD template/main -- <file>; merge by hand — CLAUDE.md keeps the project's
            header, pipeline, variables, decisions, and constraints and takes template structure;
            settings.json takes the template's hooks and keeps the project's allow list;
            .gitignore keeps project whitelists
  - append to .claude/template-sync.log: date, `git rev-parse template/main`, TAKE/REVIEW counts
  - verify: check_scaffold.py, test_hooks.py, test_scripts.py (PYTHONUTF8=1); quarto render
  - report; never merge to main or push without the user's review
```

Content that lives in PROJECT files (e.g., new sections added to the template's `domain-profile.md`
placeholder) is not pulled automatically — the status list names such files so the user can copy
sections by hand. The first sync of a project whose `journal-profiles.md` was customized moves its
paper-specific notes into `domain-profile.md` § Project-Specific Journal Notes before taking the
template's file.

---

## Bundled Resources (Level 3)

| Resource | Path | When |
|----------|------|------|
| Gotchas | `gotchas.md` | Always — known failure points |

---

## Principles
- **Each subcommand is lightweight.** No multi-agent orchestration needed.
- **Compile uses Quarto.** It handles every LaTeX pass and citeproc; latexmk is never needed.
- **validate-bib catches drift.** Run before commits to catch broken citations.
- **Upgrade preserves content.** Infrastructure changes, your paper doesn't.
