# =============================================================================
# Shiny App — Starter Template
# Run with: shiny::runApp("R/shiny")
# Or via docker-compose (uncomment the shiny service)
# =============================================================================

library(shiny)
library(ggplot2)

# -- UI -----------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Project Dashboard"),

  sidebarLayout(
    sidebarPanel(
      h4("Controls"),
      sliderInput("n_points",
        "Number of points:",
        min = 10, max = 500, value = 100
      ),
      selectInput("color",
        "Point color:",
        choices = c("steelblue", "tomato", "forestgreen", "purple"),
        selected = "steelblue"
      )
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Plot",
          plotOutput("scatter_plot", height = "500px")
        ),
        tabPanel("Data",
          tableOutput("data_table")
        ),
        tabPanel("About",
          h4("About This App"),
          p("This is a starter Shiny app template."),
          p("Replace this with your project's interactive visualizations.")
        )
      )
    )
  )
)

# -- Server -------------------------------------------------------------------
server <- function(input, output, session) {

  # Reactive data
  sample_data <- reactive({
    data.frame(
      x = rnorm(input$n_points),
      y = rnorm(input$n_points)
    )
  })

  # Scatter plot
  output$scatter_plot <- renderPlot({
    df <- sample_data()
    ggplot(df, aes(x = x, y = y)) +
      geom_point(color = input$color, alpha = 0.6, size = 3) +
      theme_minimal(base_size = 14) +
      labs(title = "Sample Scatter Plot", x = "X", y = "Y")
  })

  # Data table
  output$data_table <- renderTable({
    head(sample_data(), 20)
  })
}

# -- Run ----------------------------------------------------------------------
shinyApp(ui = ui, server = server)
