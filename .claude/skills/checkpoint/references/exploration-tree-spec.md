# Exploration Tree — Specification

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
