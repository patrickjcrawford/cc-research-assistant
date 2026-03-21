---
name: tools
description: Utility commands — commit, compile, validate-bib, journal, context-status, deploy, learn. Replaces individual utility skills.
argument-hint: "[subcommand: commit | compile | validate-bib | journal | context | deploy | learn | upgrade] [args]"
allowed-tools: Read,Grep,Glob,Write,Edit,Bash,Task
---

# Tools

Utility subcommands for project maintenance and infrastructure.

**Input:** `$ARGUMENTS` — subcommand followed by any arguments.

---

## Subcommands

### `/tools commit [message]` — Git Commit
Stage changes, create commit, optionally create PR and merge.
- Run git status to identify changes
- Stage relevant files (never stage .env or credentials)
- Create commit with descriptive message
- If quality score available and >= 80, note in commit

### `/tools compile [file]` — LaTeX Compilation
3-pass XeLaTeX + bibtex compilation.

For papers:
```bash
cd Paper && TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode [file]
BIBINPUTS=..:$BIBINPUTS bibtex [file_base]
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode [file]
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode [file]
```

For talks:
```bash
cd Talks && TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode [file]
```

### `/tools validate-bib` — Bibliography Validation
Cross-reference all \cite{} keys in paper and talk files against Bibliography_base.bib.
Report: missing entries, unused entries, duplicate keys.

### `/tools journal` — Research Journal
Regenerate the research journal timeline from quality reports and git history.
Shows chronological record of agent actions, phase transitions, scores, decisions.

### `/tools context` — Context Status
Show current context status and session health.
Check context usage, whether auto-compact is approaching, what state will be preserved.

### `/tools deploy` — Deploy Guide Site
Render Quarto guide site and publish to GitHub Pages.
```bash
cd guide && quarto publish gh-pages --no-browser
```

### `/tools learn` — Extract Learnings
Extract reusable knowledge from the current session. Auto-memory handles corrections automatically; this is for multi-step workflows worth turning into a full skill.

### `/tools upgrade` — Upgrade Clo-Author Infrastructure
Upgrade an existing project to the latest clo-author architecture.

**What it does:**
1. Check current version (read CHANGELOG.md or git tags)
2. Fetch latest clo-author from upstream
3. Replace `.claude/` directory (agents, skills, rules, references, hooks)
4. Preserve user content (paper, scripts, data — never touched)
5. Update CLAUDE.md paths if folder structure changed
6. Report what changed

**Workflow:**
```
Step 1: BACKUP
  - git stash any uncommitted work

Step 2: FETCH
  - If upstream remote exists: git fetch upstream
  - If not: git remote add upstream https://github.com/hugosantanna/clo-author.git

Step 3: REPLACE INFRASTRUCTURE
  - Copy new .claude/ from upstream (agents, skills, rules, references, hooks)
  - Copy new templates/ from upstream
  - Do NOT touch: paper/, scripts/, data/, explorations/, quality_reports/, Bibliography_base.bib

Step 4: RECONCILE
  - Read user's CLAUDE.md to find their actual folder paths
  - If their folders don't match the new defaults (e.g., Paper/ vs paper/), update
    the infrastructure paths to match THEIR structure, not the other way around
  - Preserve their domain-profile.md if it's been filled in (not just placeholders)
  - Preserve their journal-profiles.md additions

Step 5: REPORT
  - List what was updated
  - List what was preserved
  - Flag any manual action needed (e.g., "your Talks/ is now paper/talks/ in the
    new structure — rename manually or update CLAUDE.md")
```

**Key principle:** The upgrade adapts to the user's project, not the other way around. Never rename folders with content. Never overwrite filled-in profiles.

---

## Principles
- **Each subcommand is lightweight.** No multi-agent orchestration needed.
- **Compile always uses 3-pass.** Ensures references and citations resolve.
- **validate-bib catches drift.** Run before commits to catch broken citations.
- **Upgrade preserves content.** Infrastructure changes, your paper doesn't.
