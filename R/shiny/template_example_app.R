# =============================================================================
# Shiny App — Template Example: Sensor Dashboard
# =============================================================================
# Interactive dashboard for exploring the example sensor data.
# Demonstrates: reactive filtering, plots, data tables, and downloads.
#
# Run with:  make shiny
# Then open: http://localhost:3838
#
# *** DELETE THIS FILE when starting your real project ***
# =============================================================================

library(shiny)
library(ggplot2)
library(dplyr)
library(readr)

# -- Load data ----------------------------------------------------------------
# Try processed first, fall back to raw
load_sensor_data <- function() {
  processed_path <- "data/processed/template_example_sensors_clean.csv"
  raw_path <- "data/raw/template_example_sensor_data.csv"

  if (file.exists(processed_path)) {
    df <- read_csv(processed_path, show_col_types = FALSE)
    message("Loaded processed data")
  } else if (file.exists(raw_path)) {
    df <- read_csv(raw_path, show_col_types = FALSE) |>
      mutate(
        date = as.Date(date),
        status = if_else(status == "" | is.na(status), "unknown", status),
        is_healthy = status == "ok" & battery_pct > 20
      )
    message("Loaded raw data (run analysis script first for cleaned version)")
  } else {
    stop("No sensor data found. Is this a fresh project from the template?")
  }
  df
}

sensor_data <- load_sensor_data()

# -- UI -----------------------------------------------------------------------
ui <- fluidPage(
  # Simple custom CSS
  tags$head(tags$style(HTML("
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
    .well { background-color: #f8f9fa; border: 1px solid #dee2e6; }
    h2 { color: #2c3e50; }
    .status-banner {
      background: #d4edda; border: 1px solid #c3e6cb; color: #155724;
      padding: 12px 16px; border-radius: 6px; margin-bottom: 20px;
    }
  "))),

  titlePanel("Sensor Monitoring Dashboard"),

  div(class = "status-banner",
    strong("Template Example"),
    " — This is the smoke-test dashboard. If you can see this, Shiny is working! ",
    "Replace this with your real project dashboard."
  ),

  sidebarLayout(
    sidebarPanel(
      width = 3,
      h4("Filters"),

      selectInput("locations",
        "Locations:",
        choices = sort(unique(sensor_data$location)),
        selected = sort(unique(sensor_data$location)),
        multiple = TRUE
      ),

      dateRangeInput("date_range",
        "Date Range:",
        start = min(sensor_data$date),
        end = max(sensor_data$date),
        min = min(sensor_data$date),
        max = max(sensor_data$date)
      ),

      selectInput("status_filter",
        "Status:",
        choices = c("All" = "all", sort(unique(sensor_data$status))),
        selected = "all"
      ),

      hr(),
      h4("Summary"),
      verbatimTextOutput("filter_summary"),

      hr(),
      downloadButton("download_data", "Download Filtered Data")
    ),

    mainPanel(
      width = 9,
      tabsetPanel(
        id = "main_tabs",

        tabPanel("Temperature",
          br(),
          plotOutput("temp_plot", height = "400px"),
          br(),
          plotOutput("temp_hist", height = "250px")
        ),

        tabPanel("Humidity",
          br(),
          plotOutput("humidity_plot", height = "400px")
        ),

        tabPanel("Battery Health",
          br(),
          plotOutput("battery_plot", height = "400px")
        ),

        tabPanel("Data Table",
          br(),
          dataTableOutput("data_table")
        ),

        tabPanel("About",
          br(),
          h4("Template Example Dashboard"),
          p("This Shiny app is part of the R project template smoke test."),
          p("It demonstrates:"),
          tags$ul(
            tags$li("Reactive data filtering"),
            tags$li("Multiple plot types (line, boxplot, bar)"),
            tags$li("Data table display"),
            tags$li("CSV download"),
            tags$li("Loading data from the project's data/ directory")
          ),
          p(strong("When starting your real project:"), " delete this file ",
            "and the template_example data files, then build your own app.R.")
        )
      )
    )
  )
)

# -- Server -------------------------------------------------------------------
server <- function(input, output, session) {

  # Reactive filtered data
  filtered_data <- reactive({
    df <- sensor_data |>
      filter(
        location %in% input$locations,
        date >= input$date_range[1],
        date <= input$date_range[2]
      )

    if (input$status_filter != "all") {
      df <- df |> filter(status == input$status_filter)
    }
    df
  })

  # Summary text
  output$filter_summary <- renderText({
    df <- filtered_data()
    paste0(
      "Readings: ", nrow(df), "\n",
      "Sensors:  ", n_distinct(df$sensor_id), "\n",
      "Date span: ", min(df$date), " to ", max(df$date), "\n",
      "Avg temp: ", round(mean(df$temp_celsius), 1), "°C"
    )
  })

  # Temperature over time
  output$temp_plot <- renderPlot({
    filtered_data() |>
      group_by(date, location) |>
      summarise(avg_temp = mean(temp_celsius), .groups = "drop") |>
      ggplot(aes(x = date, y = avg_temp, color = location)) +
      geom_line(alpha = 0.6) +
      geom_smooth(method = "loess", se = FALSE, linewidth = 1.1) +
      theme_minimal(base_size = 14) +
      labs(title = "Temperature Trends", x = NULL, y = "Avg Temp (°C)", color = "Location") +
      scale_color_brewer(palette = "Set2")
  })

  # Temperature histogram
  output$temp_hist <- renderPlot({
    ggplot(filtered_data(), aes(x = temp_celsius, fill = location)) +
      geom_histogram(bins = 30, alpha = 0.6, position = "identity") +
      theme_minimal(base_size = 13) +
      labs(title = "Temperature Distribution", x = "Temperature (°C)", y = "Count") +
      scale_fill_brewer(palette = "Set2")
  })

  # Humidity boxplot
  output$humidity_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = location, y = humidity_pct, fill = location)) +
      geom_boxplot(alpha = 0.7) +
      theme_minimal(base_size = 14) +
      labs(title = "Humidity by Location", x = NULL, y = "Humidity (%)") +
      scale_fill_brewer(palette = "Set2") +
      theme(legend.position = "none")
  })

  # Battery health
  output$battery_plot <- renderPlot({
    filtered_data() |>
      mutate(battery_bucket = cut(battery_pct,
        breaks = c(0, 25, 50, 75, 100),
        labels = c("Critical", "Low", "Medium", "Good")
      )) |>
      count(location, battery_bucket) |>
      ggplot(aes(x = location, y = n, fill = battery_bucket)) +
      geom_col(position = "fill", alpha = 0.85) +
      scale_y_continuous(labels = scales::percent) +
      theme_minimal(base_size = 14) +
      labs(title = "Battery Health by Location", x = NULL, y = "Proportion", fill = "Level") +
      scale_fill_brewer(palette = "RdYlGn")
  })

  # Data table
  output$data_table <- renderDataTable({
    filtered_data() |>
      arrange(desc(date), sensor_id) |>
      head(500)
  }, options = list(pageLength = 25))

  # Download handler
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("sensor_data_filtered_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write_csv(filtered_data(), file)
    }
  )
}

# -- Run ----------------------------------------------------------------------
shinyApp(ui = ui, server = server)
