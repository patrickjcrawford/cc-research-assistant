# The Clo-Author: Your Econ AI Research Assistant for Claude Code

> **Work in progress.** This is an experiment born out of my discovery of [Pedro's tool](https://github.com/pedrohcgs/claude-code-my-workflow). This repo is a packaging of my own interpretation of that, tailored to pure research. It is evolving as I learn, and I share it in case others find it useful and would like to build upon it. Expect rough edges.

An open-source [Claude Code](https://docs.anthropic.com/en/docs/claude-code) workflow that turns your terminal into a full-service applied econometrics research assistant — from literature review to journal submission.

**Live guide:** [hsantanna88.github.io/clo-author](https://hsantanna88.github.io/clo-author/)
<br>**Built on:** [Pedro Sant'Anna's claude-code-my-workflow](https://github.com/pedrohcgs/claude-code-my-workflow)

---

## Quick Start

```bash
# 1. Fork and clone
gh repo fork hsantanna88/clo-author --clone
cd clo-author

# 2. Open Claude Code
claude
```

Then paste this prompt:

> I am starting a new applied econometrics research project on **[YOUR TOPIC]**.
> Read CLAUDE.md and help me set up the project structure.
> Start with a literature review on [YOUR TOPIC].

Claude reads the configuration, fills in your project details, and enters contractor mode — planning, implementing, reviewing, and verifying autonomously.

**Using VS Code?** Open the Claude Code panel instead. Everything works the same.

---

## What It Does

### Contractor Mode

You describe a task. Claude plans the approach, implements it, runs specialized review agents, fixes issues, re-verifies, and scores against quality gates — all autonomously. You approve the plan and see a summary when the work meets quality standards.

### 15 Specialized Agents in Worker-Critic Pairs

Every creator has a paired critic. Critics can't edit files; creators can't score themselves.

| Phase | Worker (Creates) | Critic (Reviews) |
|-------|-----------------|-----------------|
| Discovery | Librarian | Editor |
| Strategy | Strategist | Econometrician |
| Execution | Coder | Debugger |
| Paper | Writer | Proofreader |
| Peer Review | Referee (x2) | Editor |
| Presentation | Storyteller | Discussant |
| Infrastructure | Orchestrator, Verifier | — |

Additional standalone agents: **Explorer** (data finder), **Surveyor** (data critic).

### 29 Slash Commands

| Category | Commands |
|----------|----------|
| **Pipeline** | `/new-project`, `/interview-me`, `/lit-review`, `/find-data`, `/identify` |
| **Analysis** | `/data-analysis`, `/econometrics-check`, `/review-r` |
| **Writing** | `/draft-paper`, `/proofread`, `/humanizer` |
| **Review** | `/paper-excellence`, `/review-paper`, `/respond-to-referee` |
| **Submission** | `/target-journal`, `/submit`, `/data-deposit`, `/audit-replication`, `/pre-analysis-plan` |
| **Talks** | `/create-talk`, `/visual-audit` |
| **Infrastructure** | `/compile-latex`, `/validate-bib`, `/commit`, `/learn`, `/context-status`, `/deploy`, `/journal`, `/research-ideation` |

### Quality Gates

Weighted aggregate scoring with per-component minimums:

| Score | Gate | Applies To |
|-------|------|------------|
| 80 | Commit | Weighted aggregate (blocking) |
| 90 | PR | Weighted aggregate (blocking) |
| 95 | Submission | Aggregate + all components >= 80 |
| -- | Advisory | Talks (reported, non-blocking) |

### Context Survival

Plans, specifications, and session logs survive auto-compression and session boundaries. MEMORY.md accumulates learning across sessions — patterns discovered in one session inform future work.

---

## Project Structure

```
your-project/
├── CLAUDE.md                    # Project configuration (fill in placeholders)
├── .claude/                     # 15 agents, 29 skills, 21 rules, 7 hooks
├── Bibliography_base.bib        # Centralized bibliography
├── Paper/                       # Main LaTeX manuscript (source of truth)
│   ├── main.tex
│   └── sections/
├── Talks/                       # Derivative Beamer presentations
├── Data/                        # Raw and cleaned datasets
├── Figures/                     # Generated figures
├── Tables/                      # Generated tables
├── Supplementary/               # Online appendix
├── Replication/                 # Replication package for deposit
├── scripts/                     # Analysis code (R, Stata, Python, Julia)
├── quality_reports/             # Plans, session logs, reviews, scores
├── explorations/                # Research sandbox
└── master_supporting_docs/      # Reference papers and data docs
```

---

## Prerequisites

| Tool | Required For | Install |
|------|-------------|---------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | Everything | `npm install -g @anthropic-ai/claude-code` |
| XeLaTeX | Paper compilation | [TeX Live](https://tug.org/texlive/) or [MacTeX](https://tug.org/mactex/) |
| R | Analysis & figures | [r-project.org](https://www.r-project.org/) |
| [gh CLI](https://cli.github.com/) | GitHub integration | `brew install gh` (macOS) |

Optional: Stata, Python, Julia (for multi-language analysis), [Quarto](https://quarto.org) (web slides).

---

## Adapting for Your Field

1. **Fill in `CLAUDE.md`** — replace `[BRACKETED PLACEHOLDERS]` with your project details
2. **Fill in the domain profile** (`.claude/rules/domain-profile.md`) — your field's journals, data sources, identification strategies, conventions, and seminal references. Use `/interview-me` to populate it interactively.
3. **Configure your language** — R is the default; Stata, Python, and Julia are also supported. Set your preference in CLAUDE.md.

The Clo-Author is designed for applied econometrics, but the infrastructure (contractor mode, quality gates, adversarial review) works for any quantitative research field.

---

## Origin

This project is a fork of [Pedro Sant'Anna's claude-code-my-workflow](https://github.com/pedrohcgs/claude-code-my-workflow), which was built for Econ 730 at Emory University (6 lectures, 800+ slides). The Clo-Author reorients that infrastructure from lecture production to applied economics research publication.

The core infrastructure (contractor mode, quality gates, context survival, session logging) comes from the original template. The adversarial worker-critic architecture, econometrics-specific agents, paper drafting skills, and submission workflow are new.

Maintained by [Hugo Sant'Anna](https://hsantanna.org).

---

## License

MIT License. Fork it, customize it, make it yours.
