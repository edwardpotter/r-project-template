# =============================================================================
# Tests — Template Example: Validate data and pipeline
# =============================================================================
# These tests confirm that:
#   1. The example CSV loads correctly
#   2. Data has expected structure and content
#   3. The analysis script runs without error
#   4. Output files are generated
#
# Run with:  make test
#
# Note: testthat sets the working directory to tests/testthat/ when running
# tests. We use proj_root to reference files relative to the project root.
#
# *** DELETE THIS FILE when starting your real project ***
# =============================================================================

# -- Resolve project root (tests run from tests/testthat/) --------------------
proj_root <- normalizePath(file.path(testthat::test_path(), "..", ".."))

proj_file <- function(...) {
  file.path(proj_root, ...)
}

# Explicit column types to avoid readr guessing warnings
sensor_col_types <- readr::cols(
  date         = readr::col_date(),
  sensor_id    = readr::col_character(),
  location     = readr::col_character(),
  temp_celsius = readr::col_double(),
  humidity_pct = readr::col_double(),
  battery_pct  = readr::col_integer(),
  status       = readr::col_character()
)

# -- Test: Raw data loads and has expected structure ---------------------------

test_that("template_example raw CSV loads correctly", {
  path <- proj_file("data", "raw", "template_example_sensor_data.csv")
  expect_true(file.exists(path), info = "Raw CSV file should exist")

  df <- readr::read_csv(path, col_types = sensor_col_types)
  expect_gt(nrow(df), 500)
})

test_that("template_example raw CSV has expected columns", {
  df <- readr::read_csv(
    proj_file("data", "raw", "template_example_sensor_data.csv"),
    col_types = sensor_col_types
  )

  expected_cols <- c(
    "date", "sensor_id", "location",
    "temp_celsius", "humidity_pct", "battery_pct", "status"
  )
  expect_equal(names(df), expected_cols)
})

test_that("template_example data has expected locations", {
  df <- readr::read_csv(
    proj_file("data", "raw", "template_example_sensor_data.csv"),
    col_types = sensor_col_types
  )

  expected_locations <- c(
    "basement", "roof_north", "roof_south",
    "warehouse_a", "warehouse_b"
  )
  actual_locations <- sort(unique(df$location))
  expect_equal(actual_locations, expected_locations)
})

test_that("template_example data has reasonable value ranges", {
  df <- readr::read_csv(
    proj_file("data", "raw", "template_example_sensor_data.csv"),
    col_types = sensor_col_types
  )

  # Temperature should be roughly -10 to 50 C for indoor sensors
  expect_true(all(df$temp_celsius > -20 & df$temp_celsius < 60))

  # Humidity should be 0-100%
  expect_true(all(df$humidity_pct > 0 & df$humidity_pct <= 100))

  # Battery should be 0-100%
  expect_true(all(df$battery_pct >= 0 & df$battery_pct <= 100))
})

# -- Test: Analysis script runs and produces output ---------------------------

test_that("template_example analysis script runs without error", {
  script_path <- proj_file("R", "analysis", "01_template_example_explore.R")
  expect_true(file.exists(script_path), info = "Analysis script should exist")

  # Run the analysis script with working directory set to project root
  expect_no_error(
    withr::with_dir(proj_root, {
      source(script_path, local = TRUE)
    })
  )
})

test_that("template_example analysis produces expected output files", {
  # These should exist after running the analysis script above
  expect_true(
    file.exists(proj_file("data", "processed", "template_example_sensors_clean.csv")),
    info = "Processed data should be saved"
  )
  expect_true(
    file.exists(proj_file("data", "processed", "template_example_location_summary.csv")),
    info = "Location summary should be saved"
  )
  expect_true(
    file.exists(proj_file("output", "figures", "template_example_temp_trends.png")),
    info = "Temperature trends figure should be saved"
  )
  expect_true(
    file.exists(proj_file("output", "figures", "template_example_humidity_boxplot.png")),
    info = "Humidity boxplot figure should be saved"
  )
  expect_true(
    file.exists(proj_file("output", "figures", "template_example_battery_health.png")),
    info = "Battery health figure should be saved"
  )
})

test_that("template_example processed data has fewer or equal rows vs raw", {
  raw <- readr::read_csv(
    proj_file("data", "raw", "template_example_sensor_data.csv"),
    col_types = sensor_col_types
  )
  # Processed CSV has extra columns (month, is_healthy), so use show_col_types
  processed <- readr::read_csv(
    proj_file("data", "processed", "template_example_sensors_clean.csv"),
    show_col_types = FALSE
  )

  expect_lte(nrow(processed), nrow(raw))
  expect_gt(nrow(processed), 0)
})
