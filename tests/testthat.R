# =============================================================================
# Test runner — executes all tests in tests/testthat/
# Run with: Rscript tests/testthat.R
# =============================================================================

library(testthat)

source("R/functions/helpers.R")

test_dir("tests/testthat", reporter = "summary")
