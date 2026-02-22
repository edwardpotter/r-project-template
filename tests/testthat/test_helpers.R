# =============================================================================
# Tests for helper functions
# =============================================================================

test_that("quick_summary runs without error on a data frame", {
  df <- data.frame(a = 1:10, b = letters[1:10])
  expect_output(quick_summary(df), "Rows: 10")
  expect_output(quick_summary(df), "Cols: 2")
})

test_that("load_raw_csv errors on missing file", {
  expect_error(load_raw_csv("nonexistent_file.csv"), "File not found")
})
