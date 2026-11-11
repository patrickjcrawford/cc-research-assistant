# scripts/R/_paths.R — single source of truth for file paths in this project.
#
# Copy to scripts/R/_paths.R at project start. Every analysis script sources it:
#   source(here::here("scripts", "R", "_paths.R"))
#
# Repo data lives in data/ (gitignored, Article II). Machine-specific external
# roots come from environment variables set in .Rprofile (copy .Rprofile.example);
# no absolute path ever appears in a script (INV-16).

library(here)

# ── Repo data directory ─────────────────────────────────────────────────────
# Git worktrees (.claude/worktrees/<name>/) do not copy gitignored folders, so
# fall back to the main checkout's data/ three levels up. MARKER is a subfolder
# that only a complete data/ has; edit it for your project.
.DATA_MARKER <- "raw"

.find_data_dir <- function() {
  candidates <- c(
    here("data"),
    normalizePath(file.path(here(), "..", "..", "..", "data"), mustWork = FALSE)
  )
  for (d in candidates) {
    if (dir.exists(file.path(d, .DATA_MARKER))) return(d)
  }
  stop("Cannot locate a data/ directory containing '", .DATA_MARKER, "/'.\n",
       "Checked: ", paste(candidates, collapse = "\n         "), call. = FALSE)
}

DATA_DIR     <- .find_data_dir()
DATA_RAW     <- file.path(DATA_DIR, "raw")
DATA_CLEANED <- file.path(DATA_DIR, "cleaned")

# ── External roots (machine-specific; set in .Rprofile) ────────────────────
# Fail loudly with instructions instead of falling back to one person's paths.
.require_env <- function(var) {
  val <- Sys.getenv(var, unset = NA)
  if (is.na(val) || !nzchar(val)) {
    stop(var, " is not set. Copy .Rprofile.example to .Rprofile, set ", var,
         " for this machine, and restart R.", call. = FALSE)
  }
  if (!dir.exists(val)) stop(var, " points to a missing folder: ", val, call. = FALSE)
  val
}
# EXTERNAL_DATA_ROOT <- .require_env("EXTERNAL_DATA_ROOT")   # uncomment when used

# ── Gated writes (Article II) ───────────────────────────────────────────────
# Wrap every write to data/cleaned/ so the pipeline can run end to end without
# overwriting it:  if (!is_dry_run()) saveRDS(panel, file.path(DATA_CLEANED, "panel.rds"))
is_dry_run <- function() identical(Sys.getenv("PROJECT_DRY_RUN"), "1")
