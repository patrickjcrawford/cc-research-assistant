# Pre-Submission Checklist

## Quality Gates
- [ ] Overall score >= 95
- [ ] All component scores >= 80
- [ ] Verifier pass (0 or 100)

## Manuscript
- [ ] Abstract <= 150 words (INV-5)
- [ ] JEL codes and keywords present (INV-6)
- [ ] All tables have notes (INV-1)
- [ ] All figures have notes (INV-2)
- [ ] No `\hline` -- booktabs only (INV-3)
- [ ] Notation consistent throughout (INV-7)
- [ ] Numbers in text match tables (INV-11)
- [ ] `quarto render paper/main.qmd` completes cleanly with no warnings
- [ ] Citations via Quarto citeproc + CSL; no `biblatex`/`natbib` loaded manually (INV-9)
- [ ] Cross-references via `@fig-`/`@tbl-`/`@sec-`; no raw `\ref{}`/`\cref{}` (INV-10)
- [ ] Exhibits in the text, each after its first citation — or at the end if the journal requires it (`/paper-format end-exhibits`); Table 1 per house style (INV-23, INV-24)
- [ ] Every cited claim backed by a 🟢 (or user-assigned 🔵) claim-source-map entry; no `[NOT VERIFIED]` in text (INV-27)

## Replication Package
- [ ] README follows AEA template
- [ ] All scripts run from clean state
- [ ] Data dictionary included
- [ ] Computational requirements documented
- [ ] License specified
- [ ] Master script exists and runs end-to-end

## Submission Materials
- [ ] Cover letter drafted
- [ ] Target journal selected (from journal profiles)
- [ ] Formatting matches journal requirements
- [ ] Author information complete
- [ ] AI-use disclosure present verbatim in the title-page `thanks:` footnote: "AI DISCLOSURE: Generative AI was used for coding assistance for data analysis, proofreading, and formatting." — and it satisfies the target journal's AI policy (check the journal's submission guidelines)
- [ ] Significance stars match journal convention (INV-4)
