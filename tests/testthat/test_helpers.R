# =============================================================================
# Tests for helper functions
# =============================================================================

# Resolve project root (tests run from tests/testthat/)
proj_root <- normalizePath(file.path(testthat::test_path(), "..", ".."))

test_that("quick_summary runs without error on a data frame", {
  df <- data.frame(a = 1:10, b = letters[1:10])
  expect_output(quick_summary(df), "Rows: 10")
  expect_output(quick_summary(df), "Cols: 2")
})

test_that("load_raw_csv errors on missing file", {
  # load_raw_csv uses PATHS$raw_data which is relative, so run from project root
  withr::with_dir(proj_root, {
    expect_error(load_raw_csv("nonexistent_file.csv"), "File not found")
  })
})
