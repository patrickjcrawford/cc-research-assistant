# Citation Practice — Verifying What a Source Says

Fork-owned reference supporting INV-27 (citation provenance). Read by the librarian, librarian-critic,
writer, writer-critic, and verifier. Critics cite these as `CP-n`.

---

## Claim status in the claim-source map

| Marker | Meaning | May be cited in `main.qmd`? |
|--------|---------|------------------------------|
| 🟢 | Directly supported: verbatim passage + page recorded | Yes |
| 🟠 | Synthesis or inference across sources | Yes, worded as the paper's own argument (CP-2) |
| 🔵 | **Author-attested**: the user or a named coauthor vouches for the source; no full text available | Yes |
| 🟣 | **Author-vouched**: the text was read and supports the claim only partly, or for a different scope; the user or a named coauthor keeps the citation anyway | Yes |
| ⚪ | Design or definition statement sourced to the project's own code, config, or documents (not a cited work, not a pipeline number) | n/a — carries no citation |
| `[NOT VERIFIED]` | Passage/page could not be supplied | **No** |

**🔵 and 🟣 rules.** Only the user (or a coauthor the user names) assigns 🔵 or 🟣 — **an agent never
marks its own claim 🔵 or 🟣**, and never converts `[NOT VERIFIED]` or 🟠 to either. 🔵 is strictly for
sources with no full text available; a source that was read and does not fully support the claim is
🟣, never 🔵. The map row records who attested, the date, and the reason: for 🔵 why no passage exists
(e.g., archival volume not digitized); for 🟣 the closest passage, its page, and what it does not
cover. An agent that finds a partly supporting passage offers the author three options — reword the
sentence, mark it 🟠 and word it as the paper's argument, or keep it as 🟣 — and records the choice.
Critics do not deduct for 🔵 or 🟣. At submission the verifier lists all 🔵 and 🟣 rows in its report
(count + keys, by marker) but does not FAIL on them.

## Verification

**CP-1. Identity is not support.** A citation can pass every identity check — right author, year, page
in range, plausible topic — and still argue the opposite or cover a different case. Read the passage
and confirm it supports the claim's *direction* and scope. A 🟢 marker requires that reading.

**CP-2. Synthesis needs a source that makes the comparison.** "X and Y both show…" is 🟢 only if a
source draws that comparison. Otherwise mark it 🟠 and word it as the paper's argument ("Taken
together, X and Y suggest…"), not as a finding attributed to the literature.

**CP-3. Original language.** Quote and verify from the original-language text, never from a machine
translation (e.g., an English translation attached to the Zotero item). Translations are for
orientation only; dates, names, and technical terms drift in translation.

**CP-4. Multi-volume sources.** A source with many bib keys (gazetteer volumes, census volumes, atlas
series) is cited in full once at its first natural mention and by name afterwards; cite a specific
volume only when that volume is the point.

**CP-5. Page pins.** The claim-source map always records pages. In the manuscript, pin pages only for
specific claims — a quotation, a number, a particular entity or event — not for general attributions.

**CP-6. Keys.** Citation keys are the Better BibTeX keys from Zotero (`working-paper-format.md`
§ Citations). Never invent, hand-edit, or shorten a key; verify every `@key` against `references.bib`.
