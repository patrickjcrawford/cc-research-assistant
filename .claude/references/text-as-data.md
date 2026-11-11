# Text as Data — Bulk Extraction, LLM Labeling, and Embeddings

Fork-owned reference. Read by the data-engineer, coder, and orchestrator for any project that turns
documents into data (archival extraction, newspaper corpora, hand-coding with LLM help). Coding rules
for the resulting panel are in `empirical-practice.md` EP-15/16.

---

## Bulk extraction or labeling with subagents

- **One agent per unit**, each writing its own output file (`quality_reports/extraction/<unit>.csv` or
  similar); a consolidation script merges them afterwards. Never have agents append to a shared file.
- **Batches of about 5 concurrent agents.** Batches of 15–18 hit usage limits mid-run.
- **Check disk before re-dispatching.** An agent reported as failed has often written its file; read it
  before launching a replacement.
- Do not split a unit whose parts refer to each other (a chapter that cross-references itself).
- For row labeling: chunks of ~100–200 rows, all dispatched in one message, each given the codebook path
  and its line range; merge with a forgiving parser and auto-flag mistyped ids for audit.
- Blind benchmark agents get conceptual definitions only — no keyword lists, which leak the answer.

## LLM labels need a human audit

- A confidence threshold is not quality control. Budget a 10–15 item human audit of every batch of
  LLM-added labels before they enter training or analysis.
- Report cross-validated accuracy **separately by label source** (hand-coded vs. LLM-coded).
- Keep LLM-coded rows identifiable in the data (a `label_source` column) so results can be re-run on the
  hand-coded subset.

## Embeddings and models

- Embeddings computed outside the main pipeline must replicate its chunking and pooling exactly, and use
  the tokenizer's real `model_max_length` (not an assumed 512).
- Runtime and cost figures in notebook comments or docstrings are unreliable (one was off by 25×). Plan
  from observed runs, or say plainly that an estimate is unverified.

## Notebooks

- Edit `.ipynb` with Edit/NotebookEdit while the notebook is under the Read tool's size ceiling (about
  25k tokens). Above that, write a `.py` patch script in the scratchpad (never a heredoc — see
  `windows-environment.md`): handle each cell's `source` as either a string or a list, build literal
  newlines with `chr(10)`, and `ast.parse` every code cell after patching.
- Read and write notebook JSON with `encoding="utf-8"` and `ensure_ascii=False`.
- `git stash` before `git checkout` of a notebook with local changes.
