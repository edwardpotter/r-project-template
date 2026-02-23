# =============================================================================
# Test runner — executes all tests in tests/testthat/
# Run with: Rscript tests/testthat.R
# =============================================================================

library(testthat)

# Source helpers from project root
# Note: test_dir() changes the working directory to tests/testthat/
# so tests should use testthat::test_path() or proj_root for file paths
source("R/functions/helpers.R")

test_dir("tests/testthat", reporter = "summary")
