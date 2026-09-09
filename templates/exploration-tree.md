# Exploration Tree — [Project Name]

The shape of the research search: branch points, paths not taken, and who chose them.
Written **only** by `/checkpoint` as a session epilogue — never edited by hand mid-task.
See `.claude/rules/logging.md` § Exploration Tree for the full schema.

Append-only. Newest nodes at the bottom. To supersede a node, append a new one with
**Supersedes:** N{XX} — never edit the original.

- Node header: `### N{NN} · {type} · {provenance} · {YYYY-MM-DD}`
- Types: `question` | `decision` | `experiment` | `dead_end` | `pivot`
- Provenance: `user` | `ai-suggested` | `ai-executed` | `user-revised` (default `ai-suggested`)

---

### N01 · question · user · YYYY-MM-DD
**Parent:** root
**Title:** [root research question]
**Description:** [what is being explored and why it matters]

### N02 · decision · user · YYYY-MM-DD
**Parent:** N01
**Title:** [the choice made]
**Choice:** [what was chosen]
**Alternatives:**
- [option not chosen] — [why not]
- [option not chosen] — [why not]
**Rationale:** [why the chosen path, given the data, question, and setting]

### N03 · experiment · ai-executed · YYYY-MM-DD
**Parent:** N02
**Title:** [what was estimated]
**Result:** [what happened — include the numbers]
**Evidence:** [scripts/R/03_first_stage.R:L44 · quality_reports/results_summary.md · paper/tables/estimation/...]

### N04 · dead_end · ai-suggested · YYYY-MM-DD
**Parent:** N02
**Title:** [approach that failed]
**Hypothesis:** [what it was expected to do]
**Failure mode:** [why it failed — be specific: "first-stage F = 3.1", not "weak instrument"]
**Lesson:** [transferable takeaway that shaped the next step]

### N05 · pivot · user · YYYY-MM-DD
**Parent:** N04
**Title:** [new direction]
**From:** [previous direction]
**To:** [new direction]
**Trigger:** [what caused the change — usually a dead end, or a referee / seminar comment]

---

<!-- Real nodes go below this line. Delete the five example nodes above once the tree has content. -->
