# Outreach Style — Op-eds, Policy Blogs, and Press Pieces

Fork-owned reference. Read by the writer in `/write outreach` mode. Outreach is a different genre from
the paper: the reader is intelligent but not an economist, reads once, and stops early. Some general
guidance is adapted (paraphrased) from hanlulong/econ-writing-skill (MIT).

---

## General rules

- **No statistics apparatus.** No standard errors, p-values, confidence intervals, or "statistically
  significant". Say how sure the evidence is in words ("a consistent pattern across every
  specification", "too noisy to tell").
- **Magnitudes in everyday terms.** Translate coefficients into something a reader can picture: per
  town, per year, the size of a familiar comparison. One number per paragraph at most.
- **Lead with what you found, not with what others got wrong.** Avoid "it's not X, it's Y" framing —
  it reads as combative even when the finding is surprising. ("What moved people was market structure —
  the number of competing voices, not what any of them argued.")
- **Plain language.** No paper jargon ("the operative mechanism", "identification", "heterogeneous
  effects"). Name the method once in plain words if at all.
- **One figure**, self-explanatory, if the venue allows images.
- **End with an implication or recommendation**, not a summary.
- **Authors** come from the piece's own YAML as a structured `author:` array (a scalar is appended to the
  `_quarto.yml` authors — `quarto-gotchas.md`).
- Keep the venue's factsheet and one or two published example pieces next to the draft
  (`paper/outreach/<venue>/`) and compare against them before handing the draft over.

## Venue profile: ProMarket (Stigler Center)

- **Opening:** context or a puzzle in the first one or two paragraphs; the finding arrives in paragraph
  2–3. The editors add a blurb that front-loads the finding, so the body need not.
- **Refer to the paper as "our new research"** (or "my new research"), linked to its SSRN page — not
  "our working paper".
- **Links everywhere, with descriptive anchors:** academic claims link via anchor text such as "finance
  scholars" or "antitrust economists", not author names; named real-world examples link to journalism.
- **One named contemporary example** mid-article ("Consider two widely discussed…").
- **Implications split by audience** where natural: "For managers…", "For policymakers…".
- **Headings optional** — both headed and continuous-prose pieces appear; follow the editor.
- Typical submission format: Word (`.docx`).

## Adding a venue

Add a `## Venue profile: <name>` section with: opening structure, how to refer to the paper, linking
conventions, length, headings, submission format, and the source (factsheet, example pieces) the
profile was derived from.
