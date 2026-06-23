# Replication Package README

> Fill in all `[BRACKETED]` fields. This README follows the AEA Data and Code Availability Policy.
> Place this file at `paper/replication/README.md`.

---

## Overview

**Paper:** [Full paper title]
**Authors:** [Author 1 (affiliation)], [Author 2 (affiliation)]
**Journal:** [Target journal or "Working paper"]
**Date:** [Month Year]

This package replicates all tables and figures in the paper. The master script
`code/master.R` (or `master.py`) runs the full pipeline from raw data to final outputs.

---

## Data Availability

| Dataset | Source | Access | Notes |
|---------|--------|--------|-------|
| [Dataset name] | [URL or citation] | [Public / Restricted / Available on request] | [Key restrictions or DOI] |

**Restricted data:** [If applicable: describe how a replicator can obtain access. Include
DUA requirements, application process, and estimated processing time. If no restricted data,
delete this paragraph.]

**Data not provided:** [List any datasets you cannot redistribute and explain why.]

---

## Computational Requirements

**Software:**
- R [version] with packages: [list packages and versions, or reference `renv.lock`]
- [Python version if applicable]
- [Other software: Stata, MATLAB, etc.]

**Hardware:** Estimated runtime on [machine spec, e.g., "MacBook Pro M2, 16GB RAM"]:
- Full pipeline: approximately [X hours/minutes]
- Data-intensive steps (if any): approximately [X hours]

**Operating system:** Tested on [macOS/Windows/Linux version].

---

## File Structure

```
replication/
├── README.md               ← this file
├── code/
│   ├── master.R            ← runs everything in order
│   ├── 01_build_panel.R    ← [brief description]
│   ├── 02_analysis.R       ← [brief description]
│   └── 03_figures.R        ← [brief description]
├── data/
│   ├── raw/                ← [describe what goes here; may be empty if restricted]
│   └── cleaned/            ← [describe intermediate files]
└── output/
    ├── tables/             ← .tex files for all tables
    └── figures/            ← .pdf/.png files for all figures
```

---

## Instructions

1. **Install dependencies:** Run `renv::restore()` in R (or `pip install -r requirements.txt`)
2. **Place raw data:** Copy raw datasets to `data/raw/` per the Data Availability section
3. **Run master script:** `Rscript code/master.R` (or `python code/master.py`)
4. **Outputs:** Tables appear in `output/tables/`, figures in `output/figures/`

All paths are relative to the replication package root. Do not change the directory structure.

---

## Table and Figure Crosswalk

| Output file | Appears in | Script |
|------------|-----------|--------|
| `output/tables/tab1_summary.tex` | Table 1 | `01_build_panel.R` lines [X–Y] |
| `output/figures/fig1_trends.pdf` | Figure 1 | `03_figures.R` lines [X–Y] |
| [add rows for each output] | | |

---

## Known Issues

[List any known deviations from exact replication, e.g.:]
- Random seed produces identical estimates but figure colors may vary across OS
- [Dataset] version [X] used; newer versions may differ marginally

---

## Contact

[Corresponding author name] — [email] — [institution]

Questions about data access should be directed to [name/institution if different].
