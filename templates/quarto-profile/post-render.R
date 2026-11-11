# Profile post-render: keep this profile's .tex as paper/main-PROFILE.tex and restore the
# default-layout paper/main.tex saved by pre-render.R.
PROFILE <- "PROFILE"                                  # set to the profile name
marker  <- paste0("MARKER: ", PROFILE, "-layout profile")
tex <- file.path("paper", "main.tex")
out <- file.path("paper", paste0("main-", PROFILE, ".tex"))
bak <- file.path("paper", "main-default.tex.bak")

if (file.exists(tex) && any(grepl(marker, readLines(tex, warn = FALSE), fixed = TRUE))) {
  file.copy(tex, out, overwrite = TRUE)
  # Optional source rewrites the coauthor's layout needs go here. Write in binary mode so Windows
  # keeps LF line endings, e.g.:
  #   g <- readLines(out, warn = FALSE, encoding = "UTF-8")
  #   con <- file(out, open = "wb"); writeLines(g, con, sep = "\n", useBytes = TRUE); close(con)
  if (file.exists(bak)) {
    file.copy(bak, tex, overwrite = TRUE, copy.date = TRUE)
    file.remove(bak)
  }
}
