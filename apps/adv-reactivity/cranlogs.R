library(cranlogs)
library(dplyr)
library(lubridate)
library(ggplot2)
library(shiny)

# Define UI for specifying package and plotting cranlogs ------------
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("packages", "Package names (comma separated)"),
      actionButton("update", "Update")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define server logic for downloading and parsing cranlogs ----------
server <- function(input, output, session) {
  
  # Parses comma-separated string into a proper vector
  packages <- reactive({
    strsplit(input$packages, " *, *")[[1]]
  })
  
  # Daily downloads
  daily_downloads <- reactive({
    cranlogs::cran_downloads(
      packages = packages(),
      from = "2016-01-01", to = "2016-12-31"
    )
  })
  
  # Weekly downloads
  weekly_downloads <- reactive({
    daily_downloads() %>% 
      mutate(date = ceiling_date(date, "week")) %>%
      group_by(date, package) %>%
      summarise(count = sum(count))
  })
  
  # Plot weekly downloads, plus trendline
  output$plot <- renderPlot({
    ggplot(weekly_downloads(), aes(date, count, color = package)) +
      geom_line() +
      geom_smooth()
  })
}

# Run the app -------------------------------------------------------
shinyApp(ui, server)
