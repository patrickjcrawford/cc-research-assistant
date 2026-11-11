# Writing Practice — Reporting Results and Manuscript Hygiene

Fork-owned reference (not in upstream clo-author). Read by the writer, writer-critic, prose-critic,
and storyteller. These are template rules, not personal voice; the author's voice lives in
`.claude/references/personal-style-guide.md`. Critics cite these as `WP-n`.

---

## Reporting

**WP-1. Significance in prose is verdict words — never quoted p-values or standard errors.** Whatever
the target journal, sentences use one of:

| Word | Meaning |
|------|---------|
| significant (at the 1 / 5 percent level) | p < .01 / p < .05 |
| marginally significant | .05 ≤ p < .10 |
| indistinguishable from zero | p ≥ .10 |

Tables keep their stars, SEs, p-values, or confidence intervals per the journal profile (INV-4). Quote
an exact p-value in prose only when the claim depends on it (e.g., a pre-registered threshold). For a
headline null, say what it rules out ("rules out effects larger than 2 percent of the mean"), not a CI.

**WP-2. Magnitudes in two units.** Headline coefficients are translated into percent of the
baseline/mean of the outcome **and** absolute units, with 2–3 significant digits. Compare to a
benchmark where one exists (a known intervention, a policy threshold). When the regressor runs opposite
to the claim (a concentration index used to discuss competition, a distance used to discuss proximity),
report the effect of a move in the claim's direction and explain the sign once.

**WP-3. Prose numbers are computed, not typed.** Every number that comes from the pipeline appears in
the text as inline code, so a rerun updates the paper and INV-11 holds by construction:

- R/knitr: `` `r N$n_counties` `` · Python/jupyter engine: `` `{python} N["n_counties"]` ``
- Keep the current value in a trailing comment for readers of the source: `` `r N$n_obs` <!-- 4,316 --> ``
- A number computed only inside a script is saved first, as a small named list in a facts `.rds`
  (`paper/tables/<script>/facts.rds`); a setup chunk in `main.qmd` loads it (or a `paper/numbers.R`
  builds `N` from the saved outputs).
- **Guard verbal claims.** Where the prose says "significant" or "rises", assert it in the setup code so
  the render fails if a rerun flips it:
  `says("sig", "main_p")` with `says <- function(verdict, ...)` checking each named p against the WP-1
  thresholds and `stop()`-ing on disagreement.
- Design constants (sample window, bin width) and numbers quoted from the literature stay typed.
- `quality_reports/results_summary.md` remains the writer's map of what exists; inline code is how it
  reaches the page.

## What the main text never says

**WP-4. Never narrate the build.** No pipelines, rebuilds, scripts, notebooks, commits, versions,
"earlier codings", refinement passes, or AI-assisted steps. Present the finished data as it stands.

**WP-5. No construction caveats in the main text.** Not "still being hand-checked", "could not yet be
built", "preliminary coding". Name a proxy in one clause and move on. Limits of the data *as it is* may
be stated once; detail that matters goes to the online appendix, detail that does not is cut.

**WP-6. Only the analysis sample.** Prose, tables, and maps describe the sample that ships with the
replication package — no counts for the full source, no out-of-window or out-of-region episodes the
reader cannot see in the released data.

**WP-7. No run-in paragraph labels.** No bold or italic lead-ins opening paragraphs ("*Step 1 — scope.*",
"**Identification.**"). Turn the label into a real opening sentence that makes the claim.

**WP-8. One home per fact; appendix by name only.** See `paper-organization.md` §1: repeated facts point
to their canonical section with `@sec-`; the main text says "(online appendix)", never an appendix letter.

## Structure

**WP-9. Interpretation stays with its table.** When the paper has no Discussion section, each table's
prose keeps one or two sentences of interpretation, tied back to the introduction or background by
`@sec-` reference. A results section foreshadows a conflict with a benchmark rather than settling it
before the section built to deliver that verdict.

**WP-10. Organize by demonstration when the paper is several exercises.** For papers made of loosely
related exercises, pair each method with its result (one section per exercise) rather than one Strategy
section followed by one Results section.

## Talks

**WP-11. Talks and paper stay in sync in both directions.** A substantive slide revision is also made
in the paper, and slides are re-synced in the same pass whenever paper numbers or claims change
(INV-20, INV-21). Never cut a slide or move it to backup "for time" without asking: report the timing
budget and list skippable slides instead. Cuts for accuracy or clarity can still be recommended.
