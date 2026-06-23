# Constitutional Governance

Non-negotiable rules for this research workflow. These override all other instructions.
Amendment requires explicit user approval and a `[CONSTITUTIONAL AMENDMENT]` entry in the session log.

---

## Article I: Source-of-Truth Hierarchy

**`paper/main.qmd` is the authoritative manuscript.** All outputs (PDF, HTML, Word) derive from it.
**`scripts/R/` and `scripts/python/` are the authoritative analysis.** Tables, figures, and numbers in
the paper derive from these scripts — never the reverse.

If a number in the paper conflicts with a script output, the script is right and the paper is wrong.

*Exceptions:* None. If you need to change a number, change the script and recompile.

---

## Article II: Data Sanctity

**Raw data never enters git.** `data/raw/` and `data/cleaned/` are gitignored. Only summary outputs
(tables, figures, aggregates) commit to the repo.

**Scripts that write to `data/cleaned/` require explicit confirmation before each run.** Claude must
summarize what the script will overwrite and wait for approval — even when the user says "just do it."

**Raw data files are never deleted or overwritten by Claude**, regardless of instruction. If a raw file
needs replacement, the user handles it manually.

*Exceptions:* None.

---

## Article III: No Autonomous Remote Actions

**Claude never pushes to any remote, opens pull requests, or takes GitHub actions** — even when
explicitly asked in the same message as "just do it." These always require a separate, explicit
confirmation after the user has reviewed the local state.

*Exceptions:* None. The cost of an unwanted push is too high.

---

## Article IV: Plan-First for Multi-File Tasks

Enter plan mode and summarize the plan **before any file writes** when a task touches more than one
file or will take more than a few minutes. The summary must list: which files change, what changes,
and in what order. Wait for acknowledgment before proceeding.

For single-file edits or clearly scoped fixes, proceed directly — no plan required.

*Exceptions:* Exploration work in `explorations/` may skip planning. Typo fixes and label changes
skip planning.

---

## Article V: Co-Author Awareness

**Run `git status` and `git log --oneline -5` before bulk edits** to detect co-author changes.
If uncommitted changes exist in files you're about to edit, flag them before proceeding — do not
silently overwrite in-progress work.

Cover letters and author lists must reflect all co-authors. Never address a cover letter as if
the user is the sole author without confirming.

*Exceptions:* Files in `explorations/`, `quality_reports/`, and `.claude/` are safe to edit
without checking (they are not co-author work areas).

---

## Article VI: Quality Gate Is Blocking

**Nothing commits below 80/100.** If a script fails, a paper section scores below 80, or
compilation errors exist, the commit is blocked until fixed. This applies even on "quick fixes."

The gate applies to the artifact being changed — fixing a typo in the introduction does not
require the full paper to score >= 80, but the introduction section must.

*Exceptions:* Work-in-progress commits explicitly tagged `[WIP]` in the commit message are
exempt from the gate. Explorations are always WIP.

---

## User Preferences (Override Anytime)

These are flexible — tell Claude to change them without invoking the amendment process:

- **Citation style:** authoryear (APA-style) by default; can switch per journal
- **Significance stars:** on by default; suppressed for AEA journals automatically
- **Plot color scheme:** publication-ready (grayscale-safe) by default
- **Clustering level:** match the level of treatment variation; always justify the choice explicitly
- **Response verbosity:** concise by default; ask for more detail when needed
- **Commit message style:** imperative mood, present tense

---

## Requesting Amendment

When deviating from an Article, Claude will ask:

> "Are you **amending Article X** (permanent change) or **overriding for this task** (one-time exception)?"

**Amendment process:**
1. State the proposed change and rationale
2. Claude summarizes what breaks and what improves
3. If approved, update this file
4. Log `[CONSTITUTIONAL AMENDMENT]` in session report with date and rationale

**Review cadence:** After every 10 sessions or when an Article is violated repeatedly.
