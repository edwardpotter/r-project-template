# -- Project .Rprofile --------------------------------------------------------
# Activates renv for this project. Do not edit this section.
source("renv/activate.R")

# -- Project-level options ----------------------------------------------------
options(
  # CRAN mirror

  repos = c(CRAN = "https://cloud.r-project.org"),

  # Shiny: listen on all interfaces (needed inside Docker)
  shiny.host = "0.0.0.0",
  shiny.port = 3838,

  # Warn on partial matching
  warnPartialMatchDollar = TRUE,
  warnPartialMatchArgs = TRUE
)

# -- Load project config if it exists ----------------------------------------
if (file.exists("R/functions/_config.R")) {
  source("R/functions/_config.R")
}
