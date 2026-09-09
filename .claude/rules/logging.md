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

## Exploration Tree

The research journal records **what each agent did**. The exploration tree records **the shape of the search** — the branch points, the paths not taken, and who chose them. It is what a referee response, a methods appendix, or a co-author's "why did we…" draws on months later, when nobody remembers the four specifications that didn't work.

**Location:** `quality_reports/exploration_tree.md`
**Template:** `templates/exploration-tree.md`
**Format:** Markdown, flat append-only list of nodes. It is a DAG expressed through `Parent:` links, not physical nesting — so a new child never forces re-indenting existing content.

### When it is written

**Only as a `/checkpoint` epilogue — never mid-task.** Reading or writing the tree while an agent is working pollutes the working context. `/checkpoint` reviews the finished session, pulls out the branch points, and appends them.

### Node schema

Each node is a level-3 heading:

`### N{NN} · {type} · {provenance} · {YYYY-MM-DD}`

followed by:

- **Parent:** `N{XX}` or `root` (optionally **Also follows:** `N{YY}, N{ZZ}` for cross-edges)
- **Title:** one phrase
- type-specific fields:

| Type | Required fields | When |
|------|-----------------|------|
| `question` | Description | A research question or sub-question opens |
| `decision` | Choice, Alternatives, Rationale | A choice was made between real options |
| `experiment` | Result, Evidence | A regression / spec / test produced a result — Evidence points to a script line, table, `results_summary.md` entry, or journal entry |
| `dead_end` | Hypothesis, Failure mode, Lesson | An approach was tried and abandoned |
| `pivot` | From, To, Trigger | The project changed direction |

### Provenance tags

| Tag | Meaning |
|-----|---------|
| `user` | The user stated it or explicitly confirmed it |
| `ai-suggested` | Claude proposed it; the user did not confirm |
| `ai-executed` | Claude carried out the action |
| `user-revised` | Claude proposed it, the user corrected it |

Default to `ai-suggested` when uncertain. **Never mark a node `user` without an explicit confirmation in the transcript.**

### Rules

- **Append-only.** Never edit or delete an existing node. To supersede one, append a new node with **Supersedes:** `N{XX}`.
- **Record negatives.** A `dead_end` with a specific Failure mode and a transferable Lesson is the highest-value node. "Didn't work" is not a lesson; "first-stage F = 3.1, and the instrument also predicts the outcome directly" is.
- **Skip the routine.** Typo fixes, reruns, dependency installs, formatting — not research events.
- **Real alternatives only.** A `decision` node whose alternatives are strawmen is worse than no node.

### Who reads it

- **strategist** — recorded `dead_end` and `pivot` nodes become pre-empted objections in the strategy memo's Threats section.
- **/revise** — reads the tree before classifying referee comments; a "did you try X?" that matches a recorded `dead_end` is answered from the record, not re-run.
- **writer** — source material for a methods appendix or a "we also considered" paragraph.
- **Session recovery** — after compaction, the tree answers "have we already rejected this approach?"

The one-time strategy **decision-record** (`quality_reports/decisions/`, produced by `/strategize`) is a formal snapshot of the identification-strategy choice; exploration-tree `decision` nodes are the lightweight running trace across the whole project and may point to it.

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
