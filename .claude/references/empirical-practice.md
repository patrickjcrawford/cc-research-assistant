# Empirical Practice — Integrity, Inference, and Data Handling

Fork-owned reference (not in upstream clo-author). Read by the coder, coder-critic, data-engineer,
strategist, and methods-referee. Each rule below cost a real project a wrong result or a lost day;
the source project is noted so the reasoning can be traced. Critics cite these as `EP-n`.

---

## Integrity

**EP-1. No specification search for significance.** When the pre-specified result is null, report
the null. Any change of instrument, sample, control set, bin, or estimator must be justified on
grounds independent of its effect on the p-value, and that justification written down (strategy memo
or decision log) *before* the new result is read. A specification adopted because it "works" is a
finding about the search, not about the economy.

**EP-2. Check the sign of event time before interpreting anything.** For event studies,
distance-to-event bins, and pre/post windows, print 2–3 rows of (calendar date, event date, computed
bin) and confirm that negative means *before* the event. If the result needs a counter-intuitive
mechanism to explain it, suspect a sign or alignment bug first. (A flipped time axis produced a
plausible-looking "hypothesis confirmed" that also passed placebo tests.)

**EP-3. A result picked after looking is re-tested within its family.** A coefficient singled out
from a plot or a sweep (one topic, one subgroup, one window) is re-estimated alongside every member of
the family it was chosen from, with a BH/FDR (or Romano–Wolf) correction, before it is reported.
Report the adjusted value. (p = .006 became p_adj = .14.)

**EP-4. Read results as patterns, not stars.** A coefficient moving from the 5% to the 10% level is
not evidence against a result. First compare sign and magnitude across columns, then ask why the SE
moved (smaller N, a leveraged observation, a collinear control). Say plainly when an estimate truly
collapses — point estimate near zero with the SE unchanged.

**EP-5. Untested or deviating work is disclosed, not hidden.** A test that was planned but not run,
or a departure from the pre-specified design, gets a footnote stating the reason. The main text
reports only what was estimated.

## Inference code

**EP-6. P-values come from the estimator.** Use the estimator's degrees-of-freedom-aware output
(`fixest::pvalue()`, `coeftable()`, `summary()$coefficients`), never `2 * pnorm(-abs(t))`. A normal
approximation badly understates p-values with few clusters. With few clusters, use a wild cluster
bootstrap or randomization inference and say so.

**EP-7. One heavy estimator per process; check memory first.** Before a heavy fit, check free RAM
(Windows: `Get-CimInstance Win32_OperatingSystem`). Run each heavy estimator in its own fresh `Rscript`
process (`run_all.R` does this). Never run parallel R workers on a laptop-sized machine. Packages with a
polars backend (e.g. `DIDmultiplegtDYN`) leak memory across repeated calls: for randomization inference,
run batches in sequential fresh processes with `POLARS_MAX_THREADS=1`.

## Saving model objects (INV-13)

**EP-8. Strip the data out of saved fits.** A `fixest` object saved with `saveRDS()` carries its
`call_env` — the whole estimation data frame — plus residuals and fitted values (13.9 MB → 0.56 MB once
stripped; one unstripped fit was 718 MB). That bloats `paper/tables/` and **leaks restricted microdata
into a committed `.rds`.** Before saving:

```r
lean <- function(fit) {
  fit$call_env <- globalenv()                       # drop the captured data
  environment(fit$fml) <- globalenv()
  fit
}
models <- lapply(models, lean)
saveRDS(models, here("paper", "tables", "03_main", "reg_main.rds"))
```

Or save `summary(fit, lean = TRUE)` when the qmd only needs the table. Re-load once and confirm
`etable()` still renders before committing.

## Data handling

**EP-9. Find the consumers before overwriting a shared file.** Before overwriting a file you did not
create in this task (a panel `.rds`, a crosswalk, a codebook CSV), run `grep -rl "<filename>" scripts/
paper/` and check every script that reads it. One silent schema change broke a second pipeline.

**EP-10. Exploration code must not write production outputs.** An exploration script that
`source()`s pipeline code stubs out `saveRDS`, `ggsave`, and `write.csv` (or sets `PROJECT_DRY_RUN=1`)
so it cannot overwrite `paper/` or `data/cleaned/`. Offer an explicit flag to reuse expensive outputs
(`REUSE_X=1`) rather than ad hoc skips.

**EP-11. A ruling changes the data the same moment it changes the document.** When a coding decision is
written into a codebook or decision log, apply it to the data file the scripts actually read in the
same step. Documentation and data drifted silently once and a full retraining round ran on wrong labels.

**EP-12. Know what a partial read covers.** Before trusting a statistic from the first N rows, a byte
range, or a sample download, check what it spans (dates, categories, sources). Large files are often
stored in chronological or source order.

**EP-13. Caches are checked by content, not existence.** Restore and resume logic verifies row count,
shape, or required objects (`_cache.R`'s `expect =`), not just that the file is there; uploads
force-overwrite stale copies. Never add a helper that changes saved state around a documented config
variable — offer read-only previews, and to commit a change, edit the config and re-run.

**EP-14. Files handed to the user are UTF-8 with BOM.** CSVs meant for Excel: `readr::write_excel_csv()`
(R) or `encoding = "utf-8-sig"` (Python). Read them back with `readr::read_csv()` or
`fileEncoding = "UTF-8-BOM"` so the first column name is not corrupted. Accented names otherwise garble
on Windows.

## Hand-built data (text → panel)

**EP-15. Sparse, dated rows.** When coding unstructured sources into a panel, key each row on
(unit, date) and fill only the fields that dated passage supports. No period-range rows; a stated range
becomes two endpoint rows; a summary span ("1350–1400 was turbulent") is not a datable event.
Forward-filling is a separate, deliberate downstream step. Keep narrative cells clean and put source
metadata in note columns. Spreadsheet row ids are unstable — re-match on content keys.

**EP-16. Resolve before review.** Before handing coding rows to the user, look up the source yourself so
they see only the truly ambiguous rows. Each such row comes with the verbatim original passage, a
translation if needed, what the source does *not* say, and the options with your lean. Record each
ruling in a decision-rules file in the repo, not in memory.

**EP-17. Corrections to raw data go through the user (Article II).** Claude never writes a raw data
file, even with approval (the auto-mode classifier also blocks it). Deliver a paste-ready UTF-8-BOM CSV:
target columns adjacent, in the sheet's row order, ids checked. After the user pastes it, re-read the
sheet and verify every changed cell.
