# Logging

## Session Report
Append to `SESSION_REPORT.md` at end of session or before context compression.
**Rules:** Append only. Bullet points. Include file paths and commit hashes when available.
Create the file if it doesn't exist: `# Session Report — [Project Name]`

**Entry format:**
```markdown
## YYYY-MM-DD HH:MM — [Brief Title]

**Operations:**
- [Scripts run, files created/modified/deleted]

**Decisions:**
- [Choice made] — [rationale]

**Results:**
- [Key findings, outputs produced]

**Commits:**
- `[hash]` [commit message]

**Status:**
- Done: [what's complete]
- Pending: [what remains]
```

## Research Journal
Append to `quality_reports/research_journal.md` whenever an agent completes work — writing code, drafting a section, producing a review, making an editorial decision, or transitioning between phases.
**Rules:** Append only. One entry per agent invocation. Include phase transitions and editorial decisions.

**Entry format:**
```markdown
### YYYY-MM-DD HH:MM — [Agent Name]
**Phase:** [Discovery/Strategy/Execution/Peer Review/Presentation]
**Target:** [file or topic]
**Score:** [XX/100 or PASS/FAIL or N/A]
**Verdict:** [one line — key finding or decision]
**Report:** [path to full report]
```
**Why it exists:** Agents read this to understand pipeline state — the editor checks what strategist-critic scored, the orchestrator checks which phases passed, the coder-critic checks what the coder built. It's the shared context across agents.

Agent outputs (reports, scripts, memos, decisions) are saved to `quality_reports/` by the skills that produce them.

## Pipeline State

Structured pipeline state lives in `quality_reports/pipeline_state.json`.

**Location:** `quality_reports/pipeline_state.json`
**Template:** `templates/pipeline-state.json`
**Format:** JSON (machine-readable)

**Triggers:**
- Created when the first agent in a pipeline completes
- Updated after every agent completion, critic score, or phase transition
- Read as the first action in session recovery

**Relationship to research journal:**
- The research journal is narrative context for humans: "what happened and why"
- The pipeline state is structured context for the orchestrator: "where are we and what's next"
- They are complementary, not redundant

**Execution traces:**
After pipeline completion, the orchestrator generates an execution trace from the pipeline state and saves to `quality_reports/traces/`.

### Trace Analysis

After pipeline completion, read the execution trace and the last 5 traces (if available in `quality_reports/traces/`) to identify recurring patterns.

Analysis covers:
- Agents with first-pass >= 90 (HIGH-PERF)
- Agents that hit 3 strikes (FRICTION)
- Escalations to user (USER ESCALATION)
- Agents whose scores improved most between rounds (learning curve)

Save analysis to: `quality_reports/traces/analysis_{date}.md`

The orchestrator uses this analysis for the Learning Loop (see `orchestrator.md` Section 9).

---

## 4. Project Dashboard (Single Unified HTML)

**File:** `project_dashboard.html` in project root
**Rule:** One page, not two. No separate `research_overview.html` or `CHANGELOG.html`.

### Purpose

A single scrollable HTML page that contains **everything** about the project: research design, data inventory, identification strategy, literature, operational status, and changelog. One URL to bookmark. One page for a coauthor or advisor to open and understand the full state of the project.

### Structure (section order)

1. **Overview** — research question, causal chain, contributions, risk matrix
2. **Data** — role-based inventory (treatment/IV/outcomes/mechanism) then file-level tables with sizes. Two status labels only: `downloaded` (green) and `manual download` (amber).
3. **Identification** — IV components, specifications, exclusion restriction, fallback design
4. **Literature** — positioning, proximity rankings, gaps
5. **Code** — analysis scripts and status
6. **Quality** — component scores and gates
7. **History** — timeline of quality reports and agent outputs
8. **Plans** — active plans with status (DRAFT/APPROVED/COMPLETED)
9. **Paper** — figures/tables plan, word allocation, section structure
10. **Changelog** — reverse-chronological milestone log (see below)

### Changelog Section

The changelog is the **last section** of `project_dashboard.html`. It replaces a standalone changelog file.

**Triggers** — append a new entry when:
1. **Data acquisition** — new datasets downloaded or received
2. **Design decisions** — identification strategy chosen, target journal changed, theoretical framework adopted
3. **Code milestones** — first-stage works, main results table produced, robustness complete
4. **Paper milestones** — draft complete, submitted, R&R received, revision submitted
5. **Infrastructure** — project scaffolded, major tooling changes

**Entry format:**
```html
<div style="border-bottom:1px solid var(--g200);padding:20px 0">
  <div style="display:flex;align-items:baseline;gap:12px;margin-bottom:8px">
    <span class="entry-date">YYYY-MM-DD</span>
    <span class="pill pill-r" style="font-size:9px">data</span>
  </div>
  <div class="entry-title">What happened</div>
  <ul style="padding-left:20px;font-size:13.5px">
    <li>Bullet describing the change</li>
  </ul>
</div>
```

**Tag classes:** `pill-r` (data), `pill-accent` (design), `pill-warn` (code), `pill-pass` (paper), `pill-neutral` (infra), `pill-major` (review)

### Rules

1. **One file** — never split into multiple HTML pages
2. **Reverse chronological** changelog — newest entries first
3. **Milestone-level** — not every session, only meaningful project events
4. **Sticky nav** — main sections accessible via sticky top nav with smooth scroll
5. **Dark mode** — support `prefers-color-scheme` and manual toggle
6. **Create on scaffold** — `/new-project` generates this page with the initial "scaffolded" entry
