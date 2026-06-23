---
name: discover
description: Discovery phase combining research interviews, literature search, data discovery, and ideation. Routes to appropriate agents based on arguments. Replaces /interview-me, /lit-review, /find-data, /research-ideation.
argument-hint: "[mode: interview | lit | data | ideate] [topic or query]"
---

# Discover

Launch the Discovery phase of research. Routes to the appropriate agents based on the mode specified.

**Input:** `$ARGUMENTS` — a mode keyword followed by a topic or query.

------------------------------------------------------------------------

## Modes

### Default (no mode specified)

If no mode keyword is given, start with an interactive interview to build the research specification.

### `/discover interview [topic]` — Research Interview

Conduct a structured conversational interview to formalize a research idea.

**This is conversational.** Ask questions directly in your text responses, one or two at a time. Wait for the user to respond before continuing. Do NOT use AskUserQuestion.

**Agents:** Direct conversation (no agent dispatch) **Output:** Research specification + domain profile

Interview structure: 1. **Big Picture** (1-2 questions): "What phenomenon are you trying to understand?" "Why does this matter?" 2. **Theoretical Motivation** (1-2 questions): "What's your intuition for why X happens?" "What would standard theory predict?" 3. **Data and Setting** (1-2 questions): "What data do you have access to?" "Is there a specific institutional setting?" 4. **Identification** (1-2 questions): "Is there a natural experiment or policy change you can exploit?" "What's the biggest threat to causal interpretation?" 5. **Expected Results** (1-2 questions): "What would you expect to find?" "What would surprise you?" 6. **Contribution** (1 question): "How does this differ from what's been done? What gap are you filling?"

Interview style: - **Be curious, not prescriptive.** Draw out the researcher's thinking, don't impose your own ideas. - **Probe weak spots gently.** "What would a skeptic say about...?" not "This won't work because..." - **Build on answers.** Each question should follow from the previous response. - **Know when to stop.** If the researcher has a clear vision after 4-5 exchanges, move to the specification.

After interview (5-8 exchanges), produce three outputs:

**Output 1: Research Specification** → `quality_reports/research_spec_[topic].md`

``` markdown
# Research Specification: [Title]
## Research Question — [one sentence]
## Motivation — [why this matters, theoretical context, policy relevance]
## Hypothesis — [testable prediction with expected direction]
## Empirical Strategy — [method, treatment, control, identifying assumption, robustness]
## Data — [primary dataset, key variables, sample, unit of observation]
## Expected Results — [what the researcher expects and why]
## Contribution — [how this advances the literature]
## Open Questions — [issues needing further thought]
```

**Output 2: Domain Profile** → `.claude/references/domain-profile.md` (if still template) Fill in field, target journals, common data sources, identification strategies, field conventions, seminal references, and referee concerns based on the interview.

**Output 3: Decision Record** → `quality_reports/decisions/discovery_[topic].md` Using `templates/decision-record.md`, record: - **Decision:** The research question chosen - **Alternatives:** Other angles, framings, or questions that came up during the interview - **Why rejected:** For each alternative, why this framing was preferred (scope, data availability, novelty, feasibility) - **Key assumptions:** What must hold for this question to be answerable - **What would invalidate:** What would force a pivot (e.g., "if the policy change turns out to have been anticipated")

### `/discover lit [topic]` — Literature Review

Search and synthesize academic literature.

**Agents:** Librarian (collector) → librarian-critic (reviewer) **Output:** Annotated bibliography + BibTeX entries + frontier map

Workflow:

**Step 0: Zotero sync (attempt)**
Try to pull relevant papers from the user's Zotero library using this fallback chain:

1. **`zotero-cli` via Bash (preferred for Claude Code — lower token cost):**
   ```bash
   zotero-cli search "[topic keywords]" --limit 50
   zotero-cli search "[topic keywords]" --mode semantic --limit 20   # if semantic extra installed
   ```
   For each result, export BibTeX: `zotero-cli get metadata [KEY] --format bibtex`

2. **MCP tools (if CLI not found):**
   - `mcp__zotero__zotero_search_items` with the topic as query
   - `mcp__zotero__zotero_semantic_search` if available
   - `mcp__zotero__zotero_get_item_metadata` with `format="bibtex"` for each result

3. **If both fail:** log "Zotero unavailable in this context" and continue. Append to output: "**Zotero not synced.** For a complete library check, run `/discover zotero` in the Claude desktop app, then re-run `/discover lit`."

On success: extract titles, authors, BibTeX keys, and tags — hand to the Librarian as pre-known papers to avoid duplication and seed citation chains.

**Step 1: Load context**
Read `.claude/references/domain-profile.md` for field journals and seminal references. Read `references.bib` for papers already in the project.

**Step 2: Scan `reference_docs/supporting/`**
Check for uploaded reference material and ingest by file type:
- `.pdf` — use pdf-processing protocol (`discover/references/pdf-processing.md`)
- `.tex` — read directly
- `.bib` — extract all keys, titles, and authors; treat as pre-known papers
- `.txt` — parse line by line for DOIs (`10.xxxx/yyyy`), arXiv IDs (`arxiv:xxxx.xxxxx`), and URLs; resolve each via WebFetch (`https://doi.org/{doi}` follows to abstract page); hand resolved metadata to Librarian

**Steps 3–8: Search and synthesize**
3. Dispatch Librarian to search: Top-5 journals (AER, Econometrica, QJE, JPE, REStud), field journals from domain-profile.md, NBER/SSRN/IZA working papers, **citation chains** — forward and backward tracking from key papers (most productive search vector).
4. Assign **proximity scores**: 1 = directly competes, 2 = closely related, 3 = related, 4 = background, 5 = tangential.
5. Dispatch librarian-critic to check coverage, gaps, recency, scope.
6. If gaps found, re-dispatch Librarian for targeted search (max 1 round).
7. Save to `quality_reports/lit_review_[topic].md`.
8. Generate interactive HTML bibliography and refresh dashboard:

``` bash
python3 scripts/generate_html_report.py literature quality_reports/lit_review_[topic].md
python3 scripts/generate_dashboard.py
```

Open the HTML report for the user: `open quality_reports/lit_review_[topic].html`

**Step 9: Future reference file offer**
After saving the lit review, ask: "Save a portable future_reference.bib for use in other projects? (y/n)." If yes, write `reference_docs/supporting/future_reference.bib` containing all verified BibTeX entries from this review. The user can drop this file into any future project's `reference_docs/supporting/` and Step 2 above will pick it up automatically.

**Unverified citations:** Mark BibTeX entries with `% UNVERIFIED` if not confirmed. Do NOT fabricate or guess citation details. Cite published version when a working paper has been published.

Output format for each paper:

``` markdown
### [Author (Year)] — [Short Title]
- **Journal:** [venue]
- **Proximity:** [1-5 score]
- **Main contribution:** [1-2 sentences]
- **Identification strategy:** [DiD / IV / RDD / SC / descriptive]
- **Key finding:** [result with effect size]
- **Relevance:** [why it matters for our research]
```

### `/discover zotero [collection]` — Zotero Library Export

Export your Zotero library (or a specific collection) to `reference_docs/supporting/zotero_export.bib` so that `/discover lit` picks it up automatically in Step 2.

**Use this when:** `/discover lit` flagged "Zotero not synced" — typically because you're in Positron and `zotero-cli` isn't on PATH or the local Zotero API isn't running. Run this from Claude Desktop where the environment is configured, then switch back to Positron.

Workflow:
1. **List available collections:**
   ```bash
   zotero-cli collections list
   ```
   Or via MCP: `mcp__zotero__zotero_get_collections`

2. **Export BibTeX** — full library or named collection:
   ```bash
   # Full library search (topic-agnostic, exports everything)
   zotero-cli search "" --limit 500 | ...   # pipe item keys to bibtex export

   # Or by collection (pass collection name as argument)
   zotero-cli collections list   # find the collection key
   # then get items: mcp__zotero__zotero_get_collection_items with collection key
   # then export each: zotero-cli get metadata [KEY] --format bibtex
   ```
   For bulk export, prefer: `mcp__zotero__zotero_get_item_metadata` with `format="bibtex"` per item — more reliable than piping.

3. **Write to `reference_docs/supporting/zotero_export.bib`** — append, don't overwrite, so prior exports aren't lost.

4. Report: N entries written, collections found.

5. Prompt: "Now run `/discover lit [topic]` — `zotero_export.bib` will be picked up automatically in Step 2."

**If CLI and MCP both fail:** Report the error verbatim. Common causes: Zotero desktop not open, local API not enabled in Zotero preferences (`Tools → Developer → Allow other applications to communicate with Zotero`), or `zotero-mcp` not installed/configured.

### `/discover data [requirements]` — Data Discovery

Find and assess datasets for the research question.

**Agents:** Explorer (finder) → explorer-critic (assessor) **Output:** Ranked data sources with feasibility grades

Workflow: 1. Read research spec and strategy memo if they exist 2. Read `.claude/references/domain-profile.md` for common data sources in the field 3. Understand what variables are needed: treatment, outcome, controls, time period, geography 4. Dispatch Explorer to search across source categories: - Public microdata (CPS, ACS, NHIS, MEPS, etc.) - Administrative data (Medicare claims, tax records, court records) - Survey data (RAND HRS, PSID, Add Health, NLSY) - International (World Bank, OECD, Eurostat) - Novel/alternative (satellite imagery, web scraping, proprietary) 5. For each dataset found, report: - Name, provider, access level (public/restricted) - Key variables available - Coverage (time period, geography, sample size) - **Feasibility grade:** - **A** — Ready to use (public download, documented, standard format) - **B** — Accessible with effort (application required, moderate cost, needs cleaning) - **C** — Restricted but obtainable (FSRDC, data use agreement, IRB approval) - **D** — Very difficult (proprietary, requires partnership, rare access) - Strengths and limitations 6. Dispatch explorer-critic to critique each proposed dataset using the **5-point assessment:** 1. **Measurement validity** — Does the variable actually measure what we need? 2. **Sample selection** — Who is in the data? Who is missing? 3. **External validity** — Can we generalize from this sample? 4. **Identification compatibility** — Does this data support the proposed design? 5. **Known issues** — Documented problems with this dataset in the literature 7. Save exploration to `quality_reports/data_exploration_[topic].md`

**Rejected datasets:** Include a rejection table:

| Dataset  | Reason for Rejection          | Deal-breaker? |
|----------|-------------------------------|---------------|
| \[Name\] | \[explorer-critic's finding\] | \[Yes/No\]    |

### `/discover ideate [topic]` — Research Ideation

Generate structured research questions and hypotheses from a topic or dataset.

**Agents:** Direct generation (no agent dispatch) **Output:** Research questions with empirical strategies

Generate: 1. 3-5 research questions with clear hypotheses 2. For each: potential identification strategy, data requirements, expected contribution 3. Rank by feasibility and novelty 4. Save to `quality_reports/research_ideas_[topic].md`

------------------------------------------------------------------------

## Bundled Resources

| Resource | Path | What It Contains |
|---------------------|-----------------|-----------------------------------|
| Research spec | `discover/templates/research-spec.md` | 8-section research specification output format |
| Interview flow | `discover/templates/interview-flow.md` | 6-category conversational structure for interview mode |
| Lit review entry | `discover/templates/lit-review-entry.md` | Per-paper annotation format with proximity scoring |
| Data assessment | `discover/templates/data-assessment.md` | Data source evaluation with 5-point critique and feasibility grades |
| Research ideas | `discover/templates/research-ideas.md` | Ideation output format with feasibility/novelty ranking |
| PDF processing | `discover/references/pdf-processing.md` | Safe workflow for reading reference papers |
| Gotchas | `discover/gotchas.md` | Known failure points and edge cases |

------------------------------------------------------------------------

## Principles

- **Interview style:** Be curious, not prescriptive. Draw out the researcher's thinking.
- **Literature honesty:** Never fabricate citations. Mark unverified as `% UNVERIFIED`.
- **Proximity scoring:** Always assign 1-5 proximity scores to papers found.
- **Citation chains:** Forward and backward citation tracking is an explicit search vector — do not skip it.
- **Effect sizes matter:** Report magnitudes, not just signs. Note identification strategy for every paper.
- **Data feasibility matters:** A perfect dataset you can't access is useless. Always assign A/B/C/D grades.
- **5-point data critique:** Measurement validity, sample selection, external validity, identification compatibility, known issues. Never skip this.
- **Domain-profile aware:** Always read `.claude/references/domain-profile.md` first for field calibration.
- **Worker-critic pairing:** Librarian + librarian-critic, Explorer + explorer-critic. Never skip the critic.