# Plan: Upstream reconciliation + dissertation-project learnings → template

**Status:** APPROVED (2026-11-11) — implementing on `template/dissertation-learnings`

### Final decisions (second round, 2026-11-11)
- **P1:** fork-owned reference files + one-line pointers in upstream-owned files.
- **C29:** add 🔵 author-attested to INV-27; only the user/a named coauthor may assign it, never an agent; verifier lists 🔵 at submission, does not FAIL.
- **C41 / Article II:** (a) add paste-ready-CSV correction procedure; (b) **[CONSTITUTIONAL AMENDMENT]** hand-built, unrestricted datasets may be committed when whitelisted in `.gitignore` with a comment; (c) no-overwrite rule unchanged.
- **Tier D:** D1–D5 approved. `/write outreach` must ask which output format (docx / pdf / html / md) before drafting.
- **Tier E:** both `~/.claude/CLAUDE.md` (short, communication/commit/tooling/machine) and a filled personal-style-guide kept outside the template; fold in the `hanlulong/econ-writing-skill` review here. Show text before writing either (outside repo).

## Decision log (2026-11-11)
- **U1 merge:** YES — done. `main` fast-forwarded to `upgrade/26.09` (7011801); work branch `template/dissertation-learnings`. Not pushed.
- **U2 AEJ branch:** SKIP.
- **P1 placement:** explanation requested — pending.
- **A10 data gitignore:** YES, uncomment as `data/raw/**` + `!.gitkeep` pattern.
- **A11 (new):** `.claude/hooks/__pycache__/_hooklib.cpython-314.pyc` was committed in the 26.09 port — untrack, gitignore `__pycache__/`.
- **C12 inline numbers:** YES — inline R (`` `r x` ``), or inline Python when the paper's pipeline is Python.
- **C13 significance in prose:** TEMPLATE RULE (not journal-dependent).
- **C14 floats:** never `H`/`h`; choose `"!t"` or `"p"` by exhibit size (`"p"` for page-sized tables/figures).
- **C28 citekeys:** YES — Better BibTeX key from Zotero is authoritative; format `authorYear2keywords`.
- **C29 author-attested:** explanation requested — pending.
- **C32 critic rounds beyond 3 when mechanical:** YES.
- **C41 raw-data carve-out:** explanation requested — pending.
- **C23 event-study figures:** zero line = faint solid; reference period = dotted.
- **Tier D:** explanation requested — pending.
- **Tier E:** explanation requested — pending.
**Date:** 2026-11-11
**Sources:** `hugosantanna/clo-author` (all branches); `Dissertation/{Civil-War-News, HRE-Unrest, LC-Newspapers}` (tooling files, `_quarto.yml`, `.gitignore`, CLAUDE.md, and ~100 auto-memory `feedback_*`/`reference_*` files incl. the `acw-newspapers` and `TEST` memory dirs)

---

## Part 1 — Upstream (Hugo Sant'Anna)

| Item | State | Decision needed |
|---|---|---|
| `upstream/main` = 26.09 release (2026-10-15) | Already ported on branch `upgrade/26.09` (2026-10-31), verified, recorded as ancestor via `merge -s ours`. **Not yet merged to `main`.** | **U1.** Merge `upgrade/26.09` → `main` before starting Part 2? (recommended: yes, then branch `template/dissertation-learnings` from it) |
| `upstream/feat/aej-writing-style-guide` (2 commits, 2026-07-10, **unmerged by Hugo**) | Adds `.claude/references/writing-style-aej.md` (248 lines: AEJ section skeleton, intro template, effect-reporting sentence shape, numbering, footnotes, writer checklist + writer-critic deductions). Rewires `writer.md`: AEA style becomes the baseline voice; if `personal-style-guide.md` is empty the writer **proceeds** in AEA style instead of STOPping. | **U2.** Adopt / skip / defer. Note: its core rule ("no raw p-values or SEs in prose; significance in words") is the same preference that independently appears in all three of your projects (see C12). Adopting it would cover that item with upstream-owned text. Risk: Hugo hasn't merged it, so it may change or be dropped. |
| All other upstream branches | 0 commits ahead of `upstream/main` (gh-pages is the built site). | none |

No other upstream work is outstanding.

**Later pass (user note 2026-11-11):** review `https://github.com/hanlulong/econ-writing-skill` together with U2 and C13 — all three touch writer voice / house style; decide them jointly to avoid overlapping style guides.

---

## Part 2 — What the dissertation projects can contribute

### How the projects were compared
Each tooling file (`.claude/`, `templates/`, `_extensions/`, `.githooks/`, `paper/preambles/`, top-level `scripts/*.py`) was classified against **every historical version** of the template file:
- ~90 per project are identical to the current template; ~65 match an older template version (stale, no signal).
- Only **4–8 files per project carry genuine local edits.** The CWN agent/rule diffs are an older-template snapshot (`.tex` tables, INV-23 provenance numbering) — nothing to port.
- The bulk of the signal is in the **auto-memory feedback files** (corrections you made to Claude during real work).

### Placement principle (proposed — decision **P1**)
To stay as close to Hugo as possible, put new material in **fork-owned files** and add only one-line pointers to upstream-owned agents/rules. That keeps future `git merge upstream/main` conflicts small. Proposed new fork-owned references:
- `.claude/references/empirical-practice.md` — econometric integrity + data-construction lessons (Tier C1–C10, C38)
- `.claude/references/windows-environment.md` — all Windows quirks
- `.claude/references/llm-labeling.md` — text-as-data labeling QC
- `.claude/references/quarto-gotchas.md` — render/cache/crossref/float pitfalls
- extend existing fork-owned: `zotero-search-protocol.md`, `paper-organization.md`, `working-paper-format.md`, `sync-manifest.md`

Then register them in `sync-manifest.md` as fork-only.

---

### Tier A — Template bugs (verified; low controversy)

| # | Bug | Fix |
|---|---|---|
| A1 | `_quarto.yml` beamer format never includes `paper/preambles/beamer/slides-header.tex` (HRE and CWN both had to wire it) | add `include-in-header` + `classoptions: xcolor={x11names}` |
| A2 | `skills/talk/templates/slides-scaffold.qmd:12` points to nonexistent `paper/preambles/beamer-preamble.tex` | fix path |
| A3 | `/tools compile` (`tools/SKILL.md:43-55,157`, `tools/gotchas.md:3`) says `latexmk` + `paper/latexmkrc` — file doesn't exist; `working-paper-format.md:27` forbids latexmk; on Windows/MiKTeX this is the Perl failure you hit in LC | rewrite to `quarto render` |
| A4 | Table-note text contradicts INV-1: `content-standards.md:62,81` and `analyze/references/table-standards.md:39,51,74` tell agents to write "Robust standard errors in parentheses" in notes | align to INV-1 (etable footer already prints SE type/stars) |
| A5 | `content-standards.md:46` example uses `\label{tab:main}` (breaks `@tbl-` crossrefs, violates INV-10) | Quarto chunk-label example |
| A6 | Canonical chunks use `\|>` (`paper-organization.md:91-92`, `table-standards.md:179`) against `coding-standards-r.md:79` (`%>%`) | switch to `%>%` |
| A7 | `write/gotchas.md:10` still says `Bibliography_base.bib` / `\cite{}` | Quarto `references.bib` / `@key` |
| A8 | `personal-style-guide.md:11` "do NOT hand-edit" vs `write/gotchas.md:15` "can be hand-edited" | pick one (recommend: hand edits allowed, mark non-corpus) |
| A9 | `verifier.md:56` calls bare `Rscript` — not on PATH on some of your machines/sessions (LC) while HRE says use PATH Rscript | "Rscript from PATH; if missing, use the path in CLAUDE.md Setup" + Setup line |
| A10 | Article II says `data/raw/` and `data/cleaned/` are gitignored, but the template `.gitignore` has those patterns **commented out** | **decision A10**: uncomment as `data/raw/**` + `!.gitkeep` (recommended), or amend Article II wording |

### Tier B — Scaffold / config additions

| # | Item | Source | Rec. |
|---|---|---|---|
| B1 | `\usepackage{threeparttablex}` in `article-header.tex` | all 3 | yes |
| B2 | `\captionsetup[table]{skip=3pt}`; drop duplicated `\doublespacing` text block in `_quarto.yml` (header already sets it) | HRE | yes |
| B3 | PDF `linkcolor/citecolor/urlcolor: medium-green-grey`; `date: today` | HRE, CWN | yes (your house look) |
| B4 | `paper/preambles/revealjs/slides.scss` (Beamer palette in SCSS) + `institute: ""` under revealjs; dual-format slides scaffold | LC | yes |
| B5 | Commented `output-file: Lastname_[repo].pdf` next to `newest-version` | all 3 | yes |
| B6 | `.gitignore`: `.claude/worktrees/`, `.claude/CLAUDE.local.md`, `.Rprofile`, `*_cache/`, `paper/**/*_files/`, `data/cache/`, `*.RDataTmp`, `*.Ruserdata`, `.luarc.json`, `/paper/sections/*.tex` | LC, HRE | yes |
| B7 | `.Rprofile.example` + `scripts/R/_paths.R` template (external data roots via env vars); minimal `pyproject.toml` for `uv run` | HRE | yes |
| B8 | CLAUDE.md placeholder sections: **Key Design Decisions**, **Data & Publishing Constraints**, **Key Variables**, per-script Reads/Writes + active/retired status in Pipeline, extra compile commands (appendix, `--to revealjs`, `--profile`, `--cache-refresh`) | all 3 | yes |
| B9 | Econ-history journal profiles: JEH, EEH, EHR (+ EREH, Cliometrica written fresh), genericized from HRE's project-specific text | HRE | yes (your field) |
| B10 | `section-bibliographies` Quarto extension | HRE, LC (installed, **never used**) | skip |

### Tier C — Workflow knowledge (from feedback memories)

Grouped; each line = one learning. ★ = appeared in 2+ projects.

**Econometric / data integrity → `empirical-practice.md` + pointers in coder, coder-critic, data-engineer, methods-referee**
- C1 No specification search for significance; nulls are reported; any spec change justified independently of its p-value, in writing. (CWN; nothing in template)
- C2 Before interpreting event-study / distance-to-event output, print rows of (date, event date, bin) to confirm sign; counter-intuitive mechanism ⇒ suspect a sign bug. (CWN — produced a false "H1 confirmed")
- C3 P-values from the estimator (`fixest::pvalue()`), never `2*pnorm(-abs(t))` — few clusters. (CWN)
- C4 A result picked post hoc from a plot is re-tested within its full family with BH/FDR before reporting. (CWN: p=.006 → p_adj=.14)
- C5 Don't read results by stars: compare sign/magnitude across columns and why the SE moved (N, controls) before calling a result weakened; still say so when it truly collapses. (LC)
- C6 ★ fixest objects saved with `saveRDS()` embed the data via `call_env` (13.9 MB → 0.56 MB; up to 718 MB) and can leak restricted data into committed `.rds`; strip env / use lean summaries. (LC, HRE) — also a note under INV-13
- C7 Before overwriting a shared file you didn't create, `grep -rl` its consumers; exploration scripts that `source()` pipeline code must stub `saveRDS/ggsave/write.csv`. (CWN, HRE)
- C8 When a ruling enters a codebook/decision log, apply it to the data file the scripts read at the same time. (CWN)
- C9 Check what a partial download/sample covers before trusting a statistic from it. (CWN)
- C10 Cache-restore checks content (rows/shape), not existence; no helpers that bypass a documented config variable. (CWN)
- C11 Memory-safe runs: one heavy estimator per `Rscript` process; check free RAM; dCDH/polars leaks → sequential fresh processes, `POLARS_MAX_THREADS=1`. (HRE, CWN)

**Paper & prose → `paper-organization.md`, `working-paper-format.md`, writer, cleanup-patterns, prose-critic**
- C12 ★ **Inline-R numbers**: every pipeline number in prose is `` `r x` `` (current value in a trailing comment), script-only numbers saved to a small facts `.rds`; optional `says()`/`chk()` guards that fail the build when a verbal significance word disagrees with the value. (CWN, HRE) — **decision C12**: makes INV-11 automatic but changes the writer's workflow.
- C13 ★ **Significance in prose**: verdict words (significant / marginal / indistinguishable from zero), no quoted p-values or SEs in sentences; headline effects as % of baseline + absolute units; tables keep stars/p. (all 3) — **decision C13**: rule vs. journal-dependent; overlaps U2.
- C14 Never `H`/`h` float placement; table chunks get `tbl-pos: "!t"`; grep kept tex to confirm. Conflicts with `paper-organization.md:63` `fig-pos: "p"` for large exhibits — **decision C14** (rec: `"!t"` default, `"p"` only on request).
- C15 ★ Main text never narrates the build: no pipelines/rebuilds/commits/notebooks/AI steps/earlier codings; no "still being hand-checked" construction caveats. (CWN, HRE)
- C16 No bold/italic run-in paragraph labels ("*Step 1—scope.*") — add to AI-tell list. (HRE)
- C17 Prose, tables and maps describe only the analysis sample shipped in the replication package. (HRE)
- C18 Main text refers to "(online appendix)" only, never appendix letters/numbers; inside the appendix use `@sec-app-`/`@tbl-app-`; add a `/coherence` check for `Appendix [A-Z]` in main text. (LC)
- C19 Tests not run / deviations from the pre-specified design go in a footnote with the reason. (CWN)
- C20 One canonical home section per repeated fact; others point with `@sec-`. (HRE)
- C21 Render verification beyond exit code: `pdftotext` the PDF and grep for leaked `## `, `\begin{tabular}`, missing section numbers; asis chunks need `output: asis`. (CWN) → verifier
- C22 Quarto gotchas: knitr cache serves stale `readRDS` values (`--cache-refresh`, or `cache.extra: tools::md5sum(...)`); no `::: {#tbl-}` wrapper or raw `\label`; table notes as one string; `!expr` captions single-quoted; YAML `author:` array overrides `_quarto.yml` but a scalar appends. (CWN, HRE, LC)
- C23 Event-study figure style: dodged points + error bars, distinct shapes, dotted line at reference period, faint **solid** zero line. Conflicts with `figure-standards.md:113` (dashed) — **decision C23** (your preference vs. template default).

**Citations → INV-27, librarian(-critic), `zotero-search-protocol.md`**
- C24 A citation passing identity checks (author/year/page/topic) can still argue the opposite — the passage must support the claim's *direction*. (HRE)
- C25 A 🟠 synthesis ("X and Y both…") is worded as the paper's own argument unless a source makes the comparison. (HRE)
- C26 Quote/verify from the original-language PDF, never a machine translation. (HRE)
- C27 Multi-volume sources: cite in full once, by name afterwards; narrative `@key` when the prose names the author. (HRE)
- C28 Citekey format: template says `authorYear3keywordsTitle` (`working-paper-format.md:72`); your Zotero/BBT keys use 2 title words and BBT pins them. — **decision C28** (rec: "the Better BibTeX key Zotero generates is authoritative; never hand-edit keys").
- C29 "Author-attested" claim status (co-author vouches; no full text) beside 🟢/🟠. — **decision C29**: this amends INV-27, which currently forbids such citations.
- C30 Zotero degradation: `WinError 10061` = desktop closed (ask, don't fall back silently); invisible-text PDFs misreported as scanned (read locally with PyMuPDF/pdftotext); first semantic search can hang 1800 s; local API/BBT JSON-RPC via `curl.exe` fallbacks. (CWN, HRE, TEST)

**Agents & workflow → `rules/agents.md`, `rules/workflow.md`, orchestrator, checkpoint, talk**
- C31 Critic findings are claims: verify against source files before relaying or acting; false positives go back as "do not change". (CWN)
- C32 Small precise fixes: do directly, self-verify, then a narrowly scoped critic spot-check rather than a full round. Also allow writer-critic rounds beyond 3 when the critic calls the remainder mechanical. Conflicts with `agents.md` 3-round cap — **decision C32**.
- C33 Bulk per-unit agent dispatch: one agent per unit writing its own file, batches of ~5 (15–18 hit usage limits), check disk before re-dispatching a "failed" agent. (HRE, CWN)
- C34 `/checkpoint` **before** commit so logs ship with the work. (HRE)
- C35 Editing open files: re-read and anchor on paragraph text, not line numbers; scratchpad backup before bulk edits; draft restructures in a sibling file while you're reviewing; unexpected "changed on disk" ⇒ diff against backup. (HRE — buffer overwrite lost hours)
- C36 Costly new idea mid-task: state tradeoff, save as `plans/<date>_<idea>-proposal.md` DEFERRED, return to task. (CWN)
- C37 Compaction: keep schema/codebook/paths/remaining items; drop raw fetches. (HRE)
- C38 Text-to-panel coding: rows keyed on (unit, date), sparse fields, no period-range rows, forward-fill as a separate step; resolve-before-review (user sees only truly ambiguous rows, with verbatim passage + options). (HRE)
- C39 New-project hygiene: a sibling project's data may be reused, its prose/framing/spec choices may not be ported. (TEST) → `/new-project`
- C40 Talks: never cut slides for time without asking; slide revisions flow back to the paper; re-sync slides when paper numbers change. (CWN, LC) → storyteller, talk skill
- C41 Raw-data corrections are delivered as paste-ready UTF-8-BOM CSV (the auto-mode classifier blocks raw xlsx writes even with approval); hand-coded datasets with no other backup may need a git carve-out. — **decision C41**: touches Article II (constitutional amendment).

**Python / text-as-data → `coding-standards-python.md`, new `llm-labeling.md`**
- C42 Notebooks: Edit/NotebookEdit until ~25k tokens, then `.py` patch scripts; JSON with `encoding='utf-8'`, `ensure_ascii=False`. (CWN)
- C43 LLM labels: confidence threshold ≠ QC — 10–15 item human audit, per-source CV accuracy; subagent chunking recipe (100–200 rows, one message, CSV per chunk). (CWN)
- C44 Embeddings outside the main pipeline replicate its chunking/pooling and real `model_max_length`. (CWN)
- C45 ★ CSVs for the user: UTF-8 with BOM (`write_excel_csv`, `utf-8-sig`). (HRE)

**Windows → new `windows-environment.md` (linked from CLAUDE.md Setup)**
- C46 ★ Git Bash heredocs halve backslashes (write LaTeX/Lua/regex with Write); multi-line `Rscript -e` segfaults (use a scratch `.R`); spatial R (`sf`/`terra`) under Git Bash can segfault → PowerShell; console mangles umlauts (dump to UTF-8 file); bare `python` ≠ project env (`uv run python`); one-line `.tex` partials silently comment themselves out after the first `%`; LaTeX Workshop autoBuild → set `"never"`; never install Perl for MiKTeX errors (they're not from Quarto); `Get-CimInstance` for RAM; `hf` not `huggingface-cli`. (all 3)

### Tier D — Larger optional features (each its own decision)

| # | Feature | Source | Notes |
|---|---|---|---|
| D1 | **Downstream template sync**: `template` git remote in each project, `/tools sync-template` (fetch, diff `--name-only`, `checkout template/main -- <paths>`, record SHA); `/new-project` adds the remote | LC | Fills a real gap: `sync-manifest.md` only covers clo-author → fork. Would also make pulling *this* work into the 3 projects easy. |
| D2 | **Outreach workflow**: `paper/outreach/` scaffold (docx render, author-array override, `outreach-header.tex` single-spacing), `/write outreach` mode, `outreach-style.md` (ProMarket conventions) | LC | CLAUDE.md already advertises outreach; template folder is empty. |
| D3 | **Alternate-layout Quarto profile** pattern (`_quarto-<name>.yml`, natbib/BibTeX, pre/post-render guard so `paper/main.tex` used by `/coherence` isn't clobbered) — as documentation + skeleton, not the Geloso styling | LC | Useful for coauthors/journals needing LaTeX source. |
| D4 | **Claim-margin review PDF** (`<!--# CLAIM -->` comments → generated claim-source map + Lua filter printing claims in the margin) | CWN | Port `tools_claim_source_map.R` + `claim-margin.lua`; would need genericizing. |
| D5 | **R pipeline conventions**: `run_all.R` with fresh process per script, `save_cache()/restore_cache()` hand-off, `PROJECT_DRY_RUN=1` skipping gated writes (makes Article II confirmations workable) | HRE | Medium; template has only an example pipeline. |
| D6 | Single "promote" script output convention | CWN | **Skip**: conflicts with by-script output (INV-13/18). |

### Tier E — Personal preferences (NOT template material per `meta-governance.md`)
Belong in your user-level `~/.claude/CLAUDE.md` / user memory, so they follow you into every project without entering the public template:
- terse replies, no end-of-turn summaries; answer questions in text and wait; change only the file named; never touch another repo unasked
- commit on current branch when told; you commit per section yourself — no reminders
- one memo item at a time with original beside proposed text; revise a whole section then check in
- trim-don't-strip; say "fine, leave it" when it is; toy examples when a point doesn't land
- prose voice: first person (singular when solo), finding first, caveat once, no "This is X, not Y", no bolding, American spelling, keep strong framing (null robustness → appendix)
- R-only, `pacman::p_load()`, no renv/conda; `uv` for Python
- machine: ~12 GB RAM, zotero-mcp leak, Positron session restore

**Decision E1**: write these to user-level `~/.claude/CLAUDE.md` (always loaded) vs. user auto-memory files (recall-based). Recommended: a short `~/.claude/CLAUDE.md` section for the communication/commit rules, memory for the rest.

### Conflicts noted within your own memories (resolved toward the newer file)
- Branches: `user_profile` (cc-dev branches) vs newer `feedback_branches` (commit on main) → newer wins.
- Possessive citations: `feedback_prose_voice` (never) vs newer `feedback_narrative_citations` (narrative `@key`) → newer wins.
- Construction detail: drop vs move to appendix → compress by default; appendix only if load-bearing.
- Notebook editing: patch-script-always vs newer edit-until-ceiling → newer wins.

---

## Proposed order (after decisions)
1. Merge `upgrade/26.09` → `main` (if U1), branch `template/dissertation-learnings`.
2. Tier A bug fixes — one commit.
3. Tier B scaffold — one commit.
4. Tier C new reference files + pointers — commits grouped by destination.
5. Approved Tier D features — one commit each.
6. Update `sync-manifest.md`, CHANGELOG, SESSION_REPORT.
7. Verify: `check_scaffold.py`, `test_hooks.py`, `test_scripts.py` (`PYTHONUTF8=1`), render scaffold `main.qmd` + slides scaffold (beamer + revealjs).
8. Tier E to user-level files (outside repo; separate confirmation).
9. No push / PR (Article III).

Pulling these changes back into the three dissertation repos is a separate, later task (much easier if D1 is approved).
