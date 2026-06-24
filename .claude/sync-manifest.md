# Sync Manifest — Template vs. Project Customization

Use this file when pushing template updates to downstream projects. Each entry is labeled:

- **TEMPLATE** — pull from upstream and overwrite unconditionally. Downstream projects do not customize these.
- **PROJECT** — skip during sync. The downstream project owns this file; overwriting it destroys project-specific work.
- **MERGE** — requires manual review. The file has a template-owned section and a project-owned section. Pull template changes selectively, preserve project additions.

---

## Root

| File | Label | Notes |
|------|-------|-------|
| `CLAUDE.md` | MERGE | Template owns the structure and comments; project owns the header (project name, institution, branch), pipeline state table, pipeline diagram, and Beamer environments table. |
| `CHANGELOG.md` | TEMPLATE | Tracks template-level changes only. Projects do not edit this. |
| `README.md` | TEMPLATE | Generic template README. Projects that want a project-specific README create `README-project.md`. |
| `SESSION_REPORT.md` | PROJECT | Project session history. Never overwrite. |
| `_quarto.yml` | PROJECT | Paper-specific: title, author, font choices, custom preamble includes, citation CSL. Sync only if the project's version is missing required keys (see MERGE note below). |
| `references.bib` | PROJECT | Project bibliography. Never overwrite. |

### `_quarto.yml` MERGE guidance

Pull template changes if the project's `_quarto.yml` is missing:
- `pdf-engine: xelatex`
- `citeproc: true`
- `\doublespacing` in `include-in-header`
- `number-sections: true`

Preserve project additions: title, author, custom fonts, extra preamble includes.

---

## `.claude/`

| Path | Label | Notes |
|------|-------|-------|
| `WORKFLOW_QUICK_REF.md` | TEMPLATE | Quick reference card. No project customization needed. |
| `settings.json` | MERGE | Hook wiring (PreToolUse, PreCompact, SessionStart, PostToolUse) is template-owned. The `permissions.allow` list may have project-specific additions — preserve those, overwrite the hooks section. |
| `settings.local.json` | PROJECT | Machine-local config (API keys, local paths). Never sync. |

### `.claude/agents/`

All agent definition files are **TEMPLATE**. Downstream projects do not edit agent prompts.

| File | Label |
|------|-------|
| `coder.md` | TEMPLATE |
| `coder-critic.md` | TEMPLATE |
| `data-engineer.md` | TEMPLATE |
| `domain-referee.md` | TEMPLATE |
| `editor.md` | TEMPLATE |
| `explorer.md` | TEMPLATE |
| `explorer-critic.md` | TEMPLATE |
| `guide-writer.md` | TEMPLATE |
| `librarian.md` | TEMPLATE |
| `librarian-critic.md` | TEMPLATE |
| `methods-referee.md` | TEMPLATE |
| `orchestrator.md` | TEMPLATE |
| `storyteller.md` | TEMPLATE |
| `storyteller-critic.md` | TEMPLATE |
| `strategist.md` | TEMPLATE |
| `strategist-critic.md` | TEMPLATE |
| `theorist.md` | TEMPLATE |
| `theorist-critic.md` | TEMPLATE |
| `verifier.md` | TEMPLATE |
| `writer.md` | TEMPLATE |
| `writer-critic.md` | TEMPLATE |

### `.claude/hooks/`

All hook scripts are **TEMPLATE**. Downstream projects do not edit hook logic.

| File | Label |
|------|-------|
| `lint-scripts.sh` | TEMPLATE |
| `post-compact-restore.py` | TEMPLATE |
| `post-edit-lint.sh` | TEMPLATE |
| `post-merge.sh` | TEMPLATE |
| `pre-compact.py` | TEMPLATE |
| `protect-files.sh` | TEMPLATE |
| `session-guard.py` | TEMPLATE |

### `.claude/references/`

Split: language standards are template-owned; field/journal/style files are project-owned.

| File | Label | Notes |
|------|-------|-------|
| `coding-standards-r.md` | TEMPLATE | Language conventions, not field-specific. |
| `coding-standards-python.md` | TEMPLATE | Language conventions, not field-specific. |
| `coding-standards-julia.md` | TEMPLATE | Language conventions, not field-specific. |
| `domain-profile.md` | PROJECT | Ships empty in the template. Filled in per-researcher at project init. Never overwrite during sync. |
| `journal-profiles.md` | PROJECT | Ships empty in the template. Filled in per-researcher at project init. Never overwrite during sync. |
| `personal-style-guide.md` | PROJECT | Ships empty in the template. Filled in per-researcher at project init. Never overwrite during sync. |

### `.claude/rules/`

All rules files are **TEMPLATE**. Constitutional governance, invariants, and pipeline rules are not project-customized.

| File | Label |
|------|-------|
| `agents.md` | TEMPLATE |
| `constitutional-governance.md` | TEMPLATE |
| `content-invariants.md` | TEMPLATE |
| `content-standards.md` | TEMPLATE |
| `html-dashboard.md` | TEMPLATE |
| `lifecycle.md` | TEMPLATE |
| `logging.md` | TEMPLATE |
| `meta-governance.md` | TEMPLATE |
| `permissions.md` | TEMPLATE |
| `quality.md` | TEMPLATE |
| `revision.md` | TEMPLATE |
| `workflow.md` | TEMPLATE |
| `working-paper-format.md` | TEMPLATE |

### `.claude/skills/`

All skill files are **TEMPLATE**. Downstream projects do not edit skill logic, templates, or references.

| Path | Label |
|------|-------|
| `analyze/` | TEMPLATE |
| `careful/` | TEMPLATE |
| `checkpoint/` | TEMPLATE |
| `dashboard/` | TEMPLATE |
| `discover/` | TEMPLATE |
| `freeze/` | TEMPLATE |
| `new-project/` | TEMPLATE |
| `review/` | TEMPLATE |
| `revise/` | TEMPLATE |
| `strategize/` | TEMPLATE |
| `submit/` | TEMPLATE |
| `talk/` | TEMPLATE |
| `tools/` | TEMPLATE |
| `write/` | TEMPLATE |

### `.claude/state/`

| Path | Label | Notes |
|------|-------|-------|
| `obsidian-config.md.example` | TEMPLATE | Example file only; the actual `obsidian-config.md` (if present) is PROJECT. |
| `obsidian-config.md` | PROJECT | Machine-local Obsidian configuration. Never sync. |

---

## `paper/`

| Path | Label | Notes |
|------|-------|-------|
| `main.qmd` | PROJECT | The paper. Never overwrite. |
| `sections/` | PROJECT | Section-level .qmd files. Never overwrite. |
| `figures/` | PROJECT | Generated outputs. Never overwrite. |
| `tables/` | PROJECT | Generated outputs. Never overwrite. |
| `talks/` | PROJECT | Project-specific presentations. Never overwrite. |
| `outreach/` | PROJECT | Op-eds, press pieces. Never overwrite. |
| `replication/` | PROJECT | Replication package. Never overwrite. |
| `preambles/beamer/slides-header.tex` | TEMPLATE | Shared Beamer preamble. Overwrite unless project has custom Beamer theme. |
| `preambles/draft-article/article-header.tex` | TEMPLATE | Shared article preamble. |
| `preambles/draft-article/before-body.tex` | TEMPLATE | Shared article preamble. |
| `preambles/draft-article/title.tex` | TEMPLATE | Shared title page template. |

---

## `scripts/`

| Path | Label | Notes |
|------|-------|-------|
| `generate_dashboard.py` | TEMPLATE | Dashboard generator. Overwrite unconditionally. |
| `R/` | PROJECT | Project analysis scripts. Never overwrite. |
| `python/` | PROJECT | Project analysis scripts. Never overwrite. |

---

## `templates/`

All files under `templates/` are **TEMPLATE**. These are shared output scaffolds with no project-specific content.

| Path | Label |
|------|-------|
| `audit-10-checks.md` | TEMPLATE |
| `cover-letter.tex` | TEMPLATE |
| `diplomatic-disagreement.md` | TEMPLATE |
| `replication-readme.md` | TEMPLATE |
| `response-letter.tex` | TEMPLATE |
| `response-tracker.md` | TEMPLATE |
| `submission-checklist.md` | TEMPLATE |
| `html/base/styles.css` | TEMPLATE |
| `html/dashboard/base.html` | TEMPLATE |

---

## `quality_reports/`

Entirely **PROJECT**. All subdirectories contain project-specific scores, plans, traces, and reports.

| Path | Label |
|------|-------|
| `quality_reports/` (all contents) | PROJECT |

---

## `reference_docs/`

Entirely **PROJECT**. Contains the user's own prior papers (voice corpus) and supporting materials for the specific project.

| Path | Label |
|------|-------|
| `reference_docs/` (all contents) | PROJECT |

---

## `data/`, `explorations/`, `_output/`

Entirely **PROJECT** (and `data/` is gitignored).

| Path | Label |
|------|-------|
| `data/raw/` | PROJECT (gitignored) |
| `data/cleaned/` | PROJECT (gitignored) |
| `explorations/` | PROJECT |
| `_output/` | PROJECT |

---

## Summary: Safe to Overwrite in Bulk

When syncing template updates, you can unconditionally overwrite everything in these paths:

```
.claude/agents/
.claude/hooks/
.claude/rules/
.claude/skills/
.claude/references/coding-standards-*.md
.claude/WORKFLOW_QUICK_REF.md
templates/
scripts/generate_dashboard.py
paper/preambles/
CHANGELOG.md
README.md
```

Everything else is either **PROJECT** (skip entirely) or **MERGE** (review manually).
