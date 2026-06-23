# Coding Standards: Python

Python is a **specialist tool** in this workflow — not a peer to R. It handles tasks R can't do cleanly: web scraping, OCR/digitization of historical documents, NLP/text processing, and API calls. All econometric estimation, panel data analysis, and paper figure production stay in R.

The coder-critic enforces these rules.

---

## 1. Role in the Pipeline

**Python does:** web scraping, OCR, NLP, API calls, data collection, text cleaning, embeddings (sentence-transformers).

**R does:** everything else — econometrics, panel data, figures, tables, paper output.

**Handoff:** Python writes to `data/raw/` or `data/cleaned/` (CSV, parquet, RDS) and R reads those files. For notebook-style work, `reticulate` in `.qmd` files is acceptable but not the default.

---

## 2. Runtime and Dependencies

- **Python >= 3.11**
- **`conda`** for environment management — required when OCR binaries (tesseract) or other system-level dependencies are needed
- `environment.yml` committed to git, versions pinned
- No `pip install` inside scripts

### Core Stack

| Package | Purpose |
|---------|---------|
| `numpy` | Array operations when needed |
| `pandas` | Tabular data manipulation |
| `requests` / `httpx` | API calls, data downloads |
| `beautifulsoup4` | HTML parsing for scraping |
| `pytesseract` / `easyocr` | OCR for historical documents |
| `pdfminer.six` / `pdf2image` | PDF text extraction |
| `spacy` / `nltk` | NLP / text processing |
| `sentence-transformers` | Embeddings for text classification |
| `matplotlib` | Paper-quality figures (when Python pipeline owns the output) |
| `seaborn` | Exploratory data analysis only — not for paper figures |
| `joblib` | Parallel processing |

### Prohibited for Causal Inference

| Package | Reason | Replacement |
|---------|--------|-------------|
| `statsmodels` for main results | All inference runs in R | R / `fixest` |
| `linearmodels` for main results | All inference runs in R | R / `fixest` |
| `sklearn` for causal inference | Not designed for it | R / `fixest` |
| `plotly` for paper figures | PDF output issues, non-standard | `matplotlib` or R/ggplot2 |

`sklearn` is allowed for non-inferential ML tasks (text classification, clustering, dimensionality reduction).

---

## 2. Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Files / modules | `snake_case.py` | `scrape_census.py` |
| Functions | `snake_case` | `extract_text()` |
| Variables | `snake_case` | `n_pages`, `raw_text` |
| Constants | `UPPER_SNAKE_CASE` | `N_RETRIES`, `SEED` |
| Classes | `PascalCase` | `DocumentParser` |
| Private helpers | `_leading_underscore` | `_clean_line()` |

---

## 3. Code Style

- **Formatter:** `black` (run before commit; configured in Positron/VS Code via the Black extension)
- **Linter:** `ruff` (zero warnings; configured in Positron/VS Code via the Ruff extension)
- **Import order:** `isort` (stdlib → third-party → local)
- **Line width:** 88 characters (Black default)
- **Docstrings:** NumPy style on public functions; optional on simple helpers
- **Type hints:** best-effort — add on public functions and anywhere the types are non-obvious; skip for simple scripts

```python
from pathlib import Path
import pandas as pd

def extract_page_text(pdf_path: Path, page_num: int) -> str:
    """Extract text from a single PDF page.

    Parameters
    ----------
    pdf_path : Path
        Path to the PDF file.
    page_num : int
        Zero-indexed page number.

    Returns
    -------
    str
        Extracted text with whitespace normalized.
    """
    ...
```

---

## 4. Numerical Discipline

- All numerical computation through NumPy arrays, never Python lists
- Explicit `np.float64` when precision matters
- `np.sum()`, `np.min()`, `np.max()` — never Python builtins on arrays
- Pre-allocate result containers; never grow lists in loops

### Reproducibility

```python
# RIGHT: explicit RNG object
rng = np.random.default_rng(seed=SEED)

# WRONG: global state
np.random.seed(42)
```

### Pre-allocation

```python
# RIGHT
results = np.empty((n_docs, n_features), dtype=np.float64)
for i, doc in enumerate(documents):
    results[i] = extract_features(doc)

# WRONG: growing a list
results = []
for doc in documents:
    results.append(extract_features(doc))
```

---

## 5. Path Discipline

All paths relative to project root via `pathlib.Path`. No `os.chdir()`, no hardcoded strings.

```python
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_RAW = PROJECT_ROOT / "data" / "raw"
DATA_CLEAN = PROJECT_ROOT / "data" / "cleaned"
```

---

## 6. Parallelism

```python
from joblib import Parallel, delayed

results = Parallel(n_jobs=-1)(
    delayed(process_document)(path) for path in document_paths
)
```

Pass `rng` objects or pre-generated seeds — never rely on global state for parallel work.

---

## 7. Error Handling

- Raise `ValueError` for bad inputs, `RuntimeError` for computation failures
- Never return `None` silently on failure
- For scraping/API work, catch specific network exceptions and retry with backoff:

```python
import time
import requests
from requests.exceptions import RequestException

def fetch_with_retry(url: str, max_retries: int = 3) -> requests.Response:
    for attempt in range(max_retries):
        try:
            resp = requests.get(url, timeout=30)
            resp.raise_for_status()
            return resp
        except RequestException as e:
            if attempt == max_retries - 1:
                raise
            time.sleep(2 ** attempt)
```

---

## 8. Visualization

- **Paper figures:** `matplotlib` only (when Python pipeline produces the figure). More likely these live in R/ggplot2.
- **Exploratory EDA:** `seaborn` is fine — it's cleaner for quick visual checks during data collection and cleaning.
- `plotly` is prohibited — not reproducible as static output.

```python
# EDA (exploratory only)
import seaborn as sns
sns.histplot(data=df, x="word_count")

# Paper-quality output (if needed from Python)
import matplotlib.pyplot as plt
fig, ax = plt.subplots(figsize=(7.5, 4))
ax.plot(...)
fig.savefig(output_path, dpi=300, bbox_inches="tight")
plt.close(fig)
```

---

## 9. Prohibited Patterns

| Pattern | Reason | Replacement |
|---------|--------|-------------|
| `os.chdir()` | Breaks portability | `pathlib.Path` relative to project root |
| Hardcoded paths | Breaks portability | `pathlib.Path` from `PROJECT_ROOT` |
| `from module import *` | Namespace pollution | Explicit imports |
| Python `sum/min/max` on arrays | Slow, wrong semantics | `np.sum`, `np.min`, `np.max` |
| `np.random.seed()` global state | Not thread-safe, not parallel-safe | `np.random.default_rng(seed)` |
| Growing lists in loops | O(n²) for large n | Pre-allocate `np.empty()` |
| `except:` bare | Swallows all errors | `except SpecificError:` |
| Mutable default arguments | Shared state bug | `None` default + create inside |
| `pip install` in scripts | Breaks reproducibility | `environment.yml` |
