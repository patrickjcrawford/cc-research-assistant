# Submission Checklist

Pre-submission verification for `/submit final`. Check every item before generating submission materials.

---

## Score Gate

- [ ] Aggregate quality score >= 95/100
- [ ] Literature review >= 80
- [ ] Identification strategy >= 80
- [ ] Code quality >= 80
- [ ] Manuscript polish >= 80
- [ ] Replication readiness: PASS

---

## Manuscript

- [ ] Abstract <= 150 words
- [ ] JEL codes present (3–5 codes)
- [ ] Keywords present (4–6 terms)
- [ ] All tables have notes (source, sample, variable definitions)
- [ ] All figures have captions with data source
- [ ] No `\hline` — only booktabs rules
- [ ] No significance stars if submitting to AEA journal
- [ ] All in-text numbers match tables/figures exactly
- [ ] No causal language in descriptive sections
- [ ] Acknowledgments complete (grant numbers, data access, RA names)
- [ ] Author affiliations and emails current
- [ ] No identifying information in blind submission version (if required)
- [ ] Word count within journal limit

---

## Compilation

- [ ] `quarto render paper/main.qmd` succeeds with no errors
- [ ] No overfull hbox warnings on key figures/tables
- [ ] Bibliography compiles fully (no missing entries)
- [ ] All cross-references resolve (`\cref` produces correct labels)
- [ ] PDF bookmarks and hyperlinks work

---

## Replication Package

- [ ] Master script runs end-to-end without errors
- [ ] All tables reproduce to paper values
- [ ] All figures reproduce visually
- [ ] README present and complete (see `templates/replication-readme.md`)
- [ ] No hardcoded absolute paths anywhere
- [ ] `set.seed()` called once at top of each stochastic script
- [ ] Runtime documented in README
- [ ] Data sources documented with access instructions
- [ ] All dependencies listed (R packages with versions, or `renv.lock`)

---

## Journal-Specific

- [ ] Correct style file loaded (if journal provides one)
- [ ] Anonymized for blind review (if required)
- [ ] Cover letter drafted and reviewed (see `templates/cover-letter.tex`)
- [ ] Suggested referees list prepared (if requested)
- [ ] Conflict of interest statement included (if required)
- [ ] Data availability statement present

---

## Final Checks

- [ ] Co-authors have reviewed and approved the submission version
- [ ] All "TODO" and "FIXME" comments removed from manuscript
- [ ] No tracked changes or comments visible in PDF
- [ ] File names follow journal instructions (anonymous if blind)
- [ ] Submission portal account created and files uploaded in correct format
