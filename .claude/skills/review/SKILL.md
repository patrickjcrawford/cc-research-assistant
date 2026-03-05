---
name: review
description: All quality reviews — routes to appropriate critics based on target file type and flags. Replaces /paper-excellence, /proofread, /econometrics-check, /review-r, /review-paper.
disable-model-invocation: true
argument-hint: "[file path or --flag] Options: --peer [journal], --methods, --proofread, --code, --all"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Bash", "Task"]
---

# Review

Unified review command that routes to the appropriate critic agents based on the target and flags.

**Input:** `$ARGUMENTS` — file path and/or flags.

---

## Routing Logic

### Auto-detect by file type
- `.tex` paper file → **Comprehensive review** (writer-critic + strategist-critic + Verifier)
- `.R`, `.py`, `.do`, `.jl` file → **Code review** (coder-critic standalone, categories 4-12)
- `.tex` talk file (in Talks/) → **Talk review** (storyteller-critic)

### Explicit flags (override auto-detect)
- `--peer` → **Full peer review** (domain-referee + methods-referee, independent blind reports + editorial synthesis)
- `--peer [journal]` → **Journal-calibrated peer review** (same, but referees emulate that journal's review culture via journal-profiles.md)
- `--methods` → **Causal audit** (strategist-critic standalone, 4-phase review)
- `--proofread` → **Manuscript polish** (writer-critic standalone, 6 categories)
- `--code [file]` → **Code review** (coder-critic standalone, categories 4-12)
- `--all` or no file → **Paper excellence** (all critics in parallel + weighted score)

---

## Mode Details

### Comprehensive Review (default for .tex paper)
Dispatch in parallel:
1. **strategist-critic** — causal design audit (4 phases)
2. **writer-critic** — manuscript polish (6 categories)
3. **Verifier** — compilation check
Compute weighted aggregate score.

### Full Peer Review (`--peer` or `--peer [journal]`)
Simulates journal peer review:
1. Dispatch **domain-referee** — subject expertise review (5 dimensions, weighted)
2. Dispatch **methods-referee** — econometric methods review (5 dimensions, weighted)
3. Both reviews are independent and blind
4. If a journal name is provided, pass it to both referees — they read `journal-profiles.md` and calibrate to that journal's review culture
5. Orchestrator synthesizes editorial decision: Accept / Minor / Major / Reject
6. Save reports to `quality_reports/`

### Code Review (`--code` or auto-detect .R/.py/.do)
Dispatch **coder-critic** in standalone mode:
- Categories 4-12 only (code quality, no strategy comparison)
- Save report to `quality_reports/[file]_code_review.md`

### Causal Audit (`--methods`)
Dispatch **strategist-critic** standalone:
- Full 4-phase review (claim, design, inference, polish)
- Save report to `quality_reports/[file]_strategy_review.md`

### Manuscript Polish (`--proofread`)
Dispatch **writer-critic** standalone:
- 6 categories: structure, claims-evidence, ID fidelity, writing, grammar, compilation
- Save report to `quality_reports/[file]_proofread_report.md`

---

## Scoring

| Mode | Blocking? | Gate |
|------|-----------|------|
| Comprehensive | Yes | 80 commit, 90 PR |
| Peer Review | Yes | Referee recommendation |
| Code Review | Yes | 80 commit |
| Causal Audit | Yes | 80 commit |
| Proofread | Yes (paper), Advisory (talks) | 80 commit |

---

## Principles
- **Smart routing.** File type determines the default review mode.
- **Flags override.** Use explicit flags for targeted reviews.
- **Critics never edit.** All reviews produce reports only.
- **Proportional severity.** Phase-aware deductions per quality.md.
