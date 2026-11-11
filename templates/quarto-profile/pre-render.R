# Profile pre-render: Quarto writes the kept .tex as paper/main.tex whatever the output-file, so back up
# the default-layout main.tex before this profile's render overwrites it. post-render.R moves the new
# file aside and restores the backup. A main.tex that is itself a profile build (left by a failed run)
# is not backed up, so an earlier good backup is never overwritten.
PROFILE <- "PROFILE"                                  # set to the profile name
marker  <- paste0("MARKER: ", PROFILE, "-layout profile")
tex <- file.path("paper", "main.tex")
bak <- file.path("paper", "main-default.tex.bak")

if (file.exists(tex) && !any(grepl(marker, readLines(tex, warn = FALSE), fixed = TRUE))) {
  file.copy(tex, bak, overwrite = TRUE, copy.date = TRUE)
}
