# =============================================================================
# 01 — Exploratory Data Analysis
# =============================================================================
# This is a starter analysis script. Number your scripts to indicate
# execution order (01_, 02_, etc.)
# =============================================================================

# -- Setup --------------------------------------------------------------------
library(tidyverse)

source("R/functions/helpers.R")

# -- Load data ----------------------------------------------------------------
# df <- load_raw_csv("my_data.csv")

# -- Explore ------------------------------------------------------------------
# quick_summary(df)
# glimpse(df)

# -- Visualize ----------------------------------------------------------------
# p <- ggplot(df, aes(x = var1, y = var2)) +
#   geom_point() +
#   theme_minimal() +
#   labs(title = "Exploration", x = "Variable 1", y = "Variable 2")
#
# save_figure(p, "01_explore.png")

message("01_explore.R complete.")
