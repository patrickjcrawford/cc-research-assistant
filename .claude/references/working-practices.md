# Working Practices — Main Session and Orchestrator

Fork-owned reference, pointed to from `.claude/rules/workflow.md` and `.claude/rules/agents.md`. These
are how-to-work lessons from real projects, not research standards.

---

## Acting on critic output

- **Critic findings are claims, not facts.** Before relaying a finding to the user or sending it to a
  creator, check it against the source file. A false positive goes back to the creator explicitly as
  "do not change".
- **Small, precise fixes:** make them directly, verify them yourself against the source, then send a
  narrowly scoped critic spot-check of just those lines — not a full creator round. The critic still
  scores; only the round is smaller.
- **Mechanical punch lists may run past three rounds.** When the critic itself labels the remaining
  items mechanical (typos, a missing label, an unfulfilled forward reference), keep fixing and
  re-dispatching without asking each time. Deleting an unfulfilled promise is a valid fix.
  Substantive disagreement still escalates at three rounds (`agents.md` §4).

## Editing files the user may have open

- Edit paper files on disk, not as chat proposals.
- Re-read the file before each edit and anchor on a paragraph's opening words, not line numbers — the
  user edits in parallel and line numbers drift.
- Back up to the scratchpad before a bulk edit. While the user is reviewing a file, draft a restructure
  in a sibling file instead of in place.
- An unexpected "file changed on disk" notice may mean an editor buffer overwrote the file: diff against
  the backup before continuing.
- Inline `<!--# CLAIM ... -->` notes the user deleted mean "verified/done" — never restore them. In
  paragraph-by-paragraph passes, strip notes from paragraphs the user approved.

## Sequencing

- **Checkpoint, then commit.** At the end of a work block run `/checkpoint` first, so memory,
  `SESSION_REPORT.md`, the research journal, and the exploration tree land in the same commit as the work.
- **Defer costly new ideas.** When an expensive idea comes up mid-task: state the tradeoff, offer to
  defer, save it as `quality_reports/plans/YYYY-MM-DD_<idea>-proposal.md` with status DEFERRED, return
  to the task, and do not pitch it again unless asked.
- **Compaction summaries** keep the schema, scales, codebook, paths, decision rules, and the remaining
  items list; they drop raw fetch results and finished batches.

## Projects that share a topic

- A new project may reuse a sibling project's data and infrastructure. It may **not** port the sibling's
  prose, framing, or specification choices — those judgments are derived fresh for the new question. Ask
  when unsure.

## Provenance hygiene

- Before declaring a generator script "lost", check `git log --all -- '*name*'` and search file headers
  for the output path it writes.
- Do not state method or parameter claims ("X is sufficient", "the default is Y") without a source or
  the code in hand.
