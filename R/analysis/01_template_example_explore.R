# =============================================================================
# 01 — Template Example: Exploratory Analysis
# =============================================================================
# This script demonstrates the project workflow end-to-end:
#   1. Load raw data from data/raw/
#   2. Clean & transform
#   3. Summarize
#   4. Generate plots → output/figures/
#   5. Save processed data → data/processed/
#
# Run with:  make run SCRIPT=R/analysis/01_template_example_explore.R
#
# *** DELETE THIS FILE when starting your real project ***
# =============================================================================

# -- Setup --------------------------------------------------------------------
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

source("R/functions/helpers.R")

# -- 1. Load raw data ---------------------------------------------------------
message("Loading raw sensor data...")
sensors <- load_raw_csv("template_example_sensor_data.csv", col_types = SENSOR_COL_TYPES)
quick_summary(sensors)

# -- 2. Clean & transform -----------------------------------------------------
message("Cleaning data...")

sensors_clean <- sensors |>
  # Remove rows with extreme values (likely sensor errors)
  filter(
    temp_celsius > -10 & temp_celsius < 50,
    humidity_pct > 0 & humidity_pct <= 100
  ) |>
  # Add derived columns
  mutate(
    month = format(date, "%Y-%m"),
    is_healthy = status == "ok" & battery_pct > 20
  )

message(sprintf(
  "Cleaned: %d → %d rows (%d removed)",
  nrow(sensors), nrow(sensors_clean), nrow(sensors) - nrow(sensors_clean)
))

# -- 3. Summarize by location -------------------------------------------------
message("Summarizing by location...")

location_summary <- sensors_clean |>
  group_by(location) |>
  summarise(
    n_readings    = n(),
    avg_temp      = round(mean(temp_celsius), 1),
    avg_humidity  = round(mean(humidity_pct), 1),
    avg_battery   = round(mean(battery_pct), 1),
    pct_healthy   = round(100 * mean(is_healthy), 1),
    .groups = "drop"
  ) |>
  arrange(desc(n_readings))

print(location_summary)

# -- 4. Generate plots --------------------------------------------------------
message("Generating figures...")

# Plot 1: Temperature over time by location
p1 <- sensors_clean |>
  group_by(date, location) |>
  summarise(avg_temp = mean(temp_celsius, na.rm = TRUE), .groups = "drop") |>
  filter(!is.na(avg_temp)) |>
  ggplot(aes(x = date, y = avg_temp, color = location)) +
  geom_line(alpha = 0.7) +
  geom_smooth(method = "loess", se = FALSE, linewidth = 1.2) +
  theme_minimal(base_size = 13) +
  labs(
    title = "Average Daily Temperature by Location",
    subtitle = "Template example — sensor monitoring data",
    x = NULL, y = "Temperature (°C)", color = "Location"
  ) +
  scale_color_brewer(palette = "Set2")

save_figure(p1, "template_example_temp_trends.png", width = 10, height = 6)

# Plot 2: Humidity distribution by location
p2 <- ggplot(sensors_clean, aes(x = location, y = humidity_pct, fill = location)) +
  geom_boxplot(alpha = 0.7, outlier.alpha = 0.3) +
  theme_minimal(base_size = 13) +
  labs(
    title = "Humidity Distribution by Location",
    subtitle = "Template example — sensor monitoring data",
    x = NULL, y = "Humidity (%)"
  ) +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position = "none")

save_figure(p2, "template_example_humidity_boxplot.png", width = 8, height = 6)

# Plot 3: Battery health overview
p3 <- sensors_clean |>
  mutate(battery_bucket = cut(battery_pct,
    breaks = c(0, 25, 50, 75, 100),
    labels = c("Critical (<25%)", "Low (25-50%)", "Medium (50-75%)", "Good (>75%)")
  )) |>
  count(location, battery_bucket) |>
  ggplot(aes(x = location, y = n, fill = battery_bucket)) +
  geom_col(position = "fill", alpha = 0.85) +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal(base_size = 13) +
  labs(
    title = "Battery Health Distribution by Location",
    subtitle = "Template example — sensor monitoring data",
    x = NULL, y = "Proportion of Readings", fill = "Battery Level"
  ) +
  scale_fill_brewer(palette = "RdYlGn", direction = 1)

save_figure(p3, "template_example_battery_health.png", width = 9, height = 6)

# -- 5. Save processed data ---------------------------------------------------
message("Saving processed data...")

write_csv(sensors_clean, "data/processed/template_example_sensors_clean.csv")
write_csv(location_summary, "data/processed/template_example_location_summary.csv")

message("")
message("=== Template example analysis complete! ===")
message("  Figures saved to: output/figures/template_example_*.png")
message("  Processed data:   data/processed/template_example_*.csv")
message("")
message("If you see this, your R environment is working correctly.")
message("Delete the template_example_* files when starting your real project.")
