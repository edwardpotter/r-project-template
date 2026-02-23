# =============================================================================
# Shared Helper Functions
# Source this file or use box::use() in your analysis scripts
# =============================================================================

# -- Column types for the template_example sensor data ------------------------
# Used by analysis scripts, tests, and Shiny app to avoid readr type guessing.
# Delete this when you remove the template_example files.
SENSOR_COL_TYPES <- readr::cols(
  date         = readr::col_date(),
  sensor_id    = readr::col_character(),
  location     = readr::col_character(),
  temp_celsius = readr::col_double(),
  humidity_pct = readr::col_double(),
  battery_pct  = readr::col_integer(),
  status       = readr::col_character()
)

#' Load and clean a CSV from the raw data directory
#'
#' @param filename Name of the CSV file (in data/raw/)
#' @param ... Additional arguments passed to readr::read_csv
#' @return A tibble
load_raw_csv <- function(filename, ...) {
  path <- file.path(PATHS$raw_data, filename)
  if (!file.exists(path)) {
    stop(sprintf("File not found: %s", path))
  }
  readr::read_csv(path, show_col_types = FALSE, ...)
}

#' Save a ggplot figure to the output directory
#'
#' @param plot A ggplot object
#' @param filename Output filename (e.g., "my_plot.png")
#' @param width Width in inches (default 8)
#' @param height Height in inches (default 6)
#' @param dpi Resolution (default 300)
save_figure <- function(plot, filename, width = 8, height = 6, dpi = 300) {
  path <- file.path(PATHS$figures, filename)
  ggplot2::ggsave(path, plot = plot, width = width, height = height, dpi = dpi)
  message(sprintf("Figure saved: %s", path))
}

#' Quick summary of a data frame
#'
#' @param df A data frame or tibble
#' @return Invisible; prints summary to console
quick_summary <- function(df) {
  cat(sprintf("Rows: %d | Cols: %d\n", nrow(df), ncol(df)))
  cat(sprintf("Column types: %s\n",
    paste(names(table(sapply(df, class))), collapse = ", ")
  ))
  cat(sprintf("Missing values: %d (%.1f%%)\n",
    sum(is.na(df)),
    100 * sum(is.na(df)) / (nrow(df) * ncol(df))
  ))
  invisible(df)
}
