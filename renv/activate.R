# renv activate script — auto-generated placeholder
# This file will be replaced when you run renv::init() inside the container.
# It bootstraps renv so that the project uses its own private library.

local({
  # Check if renv is installed
  if (!requireNamespace("renv", quietly = TRUE)) {
    message("renv is not installed. Installing...")
    install.packages("renv", repos = "https://cloud.r-project.org")
  }
  # Activate the project
  renv::activate(project = getwd())
})
