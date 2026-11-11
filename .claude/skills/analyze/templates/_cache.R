# scripts/R/_cache.R — hand objects from one pipeline file to the next.
#
# Copy to scripts/R/_cache.R. A later script never source()s an earlier one
# (that re-runs the whole chain, including its gated data/cleaned/ writes).
# Instead the producer calls save_cache("name") once and the consumer calls
# restore_cache("name") where it needs those objects.
#
# data/cache/ is gitignored and fully regenerable — it is NOT data/cleaned/, so
# writing it is not an Article II gated action. Delete it freely.

CACHE_DIR <- here::here("data", "cache")

# Which script produces each cache entry (used in the error message). Edit per project.
CACHE_PRODUCERS <- c(
  # analysis_panel = "02_build_panel.R",
)

CACHE_EXCLUDE <- c("CACHE_DIR", "CACHE_PRODUCERS", "CACHE_EXCLUDE",
                   "save_cache", "restore_cache")

save_cache <- function(name, objects = ls(envir = globalenv()), envir = globalenv()) {
  objects <- setdiff(objects, CACHE_EXCLUDE)
  dir.create(CACHE_DIR, recursive = TRUE, showWarnings = FALSE)
  saveRDS(mget(objects, envir = envir), file.path(CACHE_DIR, paste0(name, ".rds")))
  message("CACHED ", length(objects), " objects -> data/cache/", name, ".rds")
  invisible(objects)
}

restore_cache <- function(name, envir = globalenv(), expect = NULL) {
  path <- file.path(CACHE_DIR, paste0(name, ".rds"))
  if (!file.exists(path)) {
    producer <- if (name %in% names(CACHE_PRODUCERS)) CACHE_PRODUCERS[[name]] else "its producer"
    stop("Missing data/cache/", name, ".rds -- run ", producer, " first.", call. = FALSE)
  }
  objs <- readRDS(path)
  # A cache that exists is not necessarily a cache that is right: check content.
  missing <- setdiff(expect, names(objs))
  if (length(missing)) {
    stop("data/cache/", name, ".rds lacks: ", paste(missing, collapse = ", "),
         " -- rerun its producer.", call. = FALSE)
  }
  # Path objects are configuration, not data: never let a stale cache overwrite
  # the paths _paths.R set in this session.
  objs <- objs[!grepl("^(PATH_|DATA_)", names(objs))]
  list2env(objs, envir = envir)
  message("RESTORED data/cache/", name, ".rds")
  invisible(NULL)
}
