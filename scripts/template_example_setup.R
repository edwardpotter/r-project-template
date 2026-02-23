# =============================================================================
# template_example_setup.R — Install packages needed for the smoke test
# =============================================================================
# Run with:  make setup
#
# Installs core packages into the renv cache, then snapshots renv.lock.
# This only needs to run once after 'make build' — subsequent containers
# will restore from the updated lockfile.
#
# *** Modify this file to add your own project's core dependencies ***
# =============================================================================

message("=== Installing project dependencies ===")
message("")

# -- Packages required for template_example smoke test ------------------------
smoke_test_pkgs <- c(
  "readr",
  "dplyr",
  "tidyr",
  "ggplot2",
  "shiny",
  "scales",
  "testthat",
  "withr"       # Used by tests for with_dir() (working directory management)
)

# -- Packages you'll likely want for real projects (uncomment as needed) ------
# project_pkgs <- c(
#   "tidyverse",    # readr + dplyr + tidyr + ggplot2 + purrr + stringr + forcats + tibble
#   "janitor",      # Data cleaning helpers
#   "lubridate",    # Date/time handling
#   "here",         # Project-relative paths
#   "DBI",          # Database interface
#   "RPostgres",    # PostgreSQL driver
#   "jsonlite",     # JSON parsing
#   "httr2",        # HTTP requests
#   "lintr",        # Code linting
# )

all_pkgs <- smoke_test_pkgs
# all_pkgs <- c(smoke_test_pkgs, project_pkgs)  # uncomment when adding your own

# -- Install ------------------------------------------------------------------
message(sprintf("Installing %d packages: %s", length(all_pkgs), paste(all_pkgs, collapse = ", ")))
message("")

renv::install(all_pkgs, prompt = FALSE)

# -- Snapshot lockfile --------------------------------------------------------
message("")
message("Snapshotting renv.lock...")
renv::snapshot(prompt = FALSE)

message("")
message("=== Setup complete! ===")
message("Packages installed and renv.lock updated.")
message("Run 'make smoke-test' to verify everything works.")
