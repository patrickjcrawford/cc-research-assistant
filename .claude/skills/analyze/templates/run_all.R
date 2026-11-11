# scripts/R/run_all.R — run the analysis pipeline in order.
#
# Copy to scripts/R/run_all.R and list the project's numbered scripts below.
# Each file runs in a FRESH R process, so no file silently depends on objects
# another left behind (hand-offs go through data/cache/ via _cache.R), and
# memory from one heavy estimator is released before the next starts.
#
# Usage (from the project root):
#   Rscript scripts/R/run_all.R              # full build
#   Rscript scripts/R/run_all.R 04           # start at the file beginning "04"
#   PROJECT_DRY_RUN=1 Rscript scripts/R/run_all.R   # skip every data/cleaned/ write
#     (PowerShell: $env:PROJECT_DRY_RUN = "1"; Rscript scripts/R/run_all.R)
#
# Article II: scripts that write data/cleaned/ are marked with * below. Confirm
# before running them for real; a dry run needs no confirmation.

library(here)

PIPELINE <- c(
  # "01_clean_raw.R",        # *
  # "02_build_panel.R",      # *
  # "03_main_estimation.R",
  # "04_robustness.R"
)

args <- commandArgs(trailingOnly = TRUE)
start_at <- if (length(args)) which(startsWith(PIPELINE, args[1])) else 1L
if (!length(PIPELINE)) stop("PIPELINE is empty -- list the project's scripts in run_all.R.")
if (!length(start_at)) stop("No pipeline file starts with '", args[1], "'.")

rscript <- file.path(R.home("bin"), "Rscript")   # the R running this file, not whatever is on PATH
log_dir <- here("_output", "pipeline_logs")
dir.create(log_dir, recursive = TRUE, showWarnings = FALSE)

for (f in PIPELINE[start_at:length(PIPELINE)]) {
  log_path <- file.path(log_dir, sub("[.]R$", ".log", f))
  message(format(Sys.time(), "%H:%M:%S"), "  running ", f, " -> ", log_path)
  t0 <- Sys.time()
  status <- system2(rscript, here("scripts", "R", f), stdout = log_path, stderr = log_path)
  message("          done in ", round(difftime(Sys.time(), t0, units = "mins"), 1),
          " min (exit ", status, ")")
  if (status != 0) stop(f, " failed -- see ", log_path, call. = FALSE)
}
message("Pipeline complete.")
