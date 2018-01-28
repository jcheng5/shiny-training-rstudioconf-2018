library(shiny)
library(ggplot2)
library(leaflet)
library(dplyr)
library(shinydashboard)

# From https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.csv
earthquakes <- read.csv("earthquakes.csv", stringsAsFactors = FALSE)
earthquakes$time <- lubridate::parse_date_time(earthquakes$time, orders="ymd HMS")

ui <- dashboardPage(
  dashboardHeader(title = "USGS Earthquake Explorer"),
  dashboardSidebar(
    dateRangeInput("dates", "Date range",
      start = as.Date(min(earthquakes$time)),
      end = as.Date(max(earthquakes$time)),
      min = as.Date(min(earthquakes$time)),
      max = as.Date(max(earthquakes$time))
    ),
    actionButton("reset_dates", "Reset date range")
  ),
  dashboardBody(
    fluidRow(
      valueBoxOutput("count", width = 4),
      valueBoxOutput("median", width = 4),
      valueBoxOutput("mtbq", width = 4)
    ),
    fluidRow(
      box(width = 12,
        leafletOutput("map")
      )
    ),
    fluidRow(
      box(
        plotOutput("scatter")
      ),
      box(
        plotOutput("mag_hist")
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$reset_dates, {
    updateDateRangeInput(session, "dates",
      start = as.Date(min(earthquakes$time)),
      end = as.Date(max(earthquakes$time))
    )
  })
  
  quakes_subset <- reactive({
    earthquakes %>%
      filter(time >= input$dates[[1]] & as.Date(time) <= input$dates[[2]])
  })
  
  output$count <- renderValueBox({
    valueBox(
      nrow(quakes_subset()),
      "Number of quakes",
      icon = icon("globe")
    )
  })
  
  output$median <- renderValueBox({
    valueBox(
      median(quakes_subset()$mag),
      "Median magnitude",
      icon = icon("line-chart")
    )
  })
  
  output$mtbq <- renderValueBox({
    by_time <- quakes_subset()
    diffs <- difftime(head(by_time$time, -1), tail(by_time$time, -1), "minutes")
    mtbq <- mean(diffs)
    valueBox(
      paste(formatC(mtbq), units(mtbq)),
      "Mean time between quakes",
      icon = icon("clock-o")
    )
  })

  output$scatter <- renderPlot({
    ggplot(quakes_subset(), aes(time, mag, color = depth)) +
      geom_point(alpha = 0.4)
  })
  
  output$mag_hist <- renderPlot({
    ggplot(quakes_subset(), aes(mag)) +
      geom_histogram(fill = "#99BBFF")
  })
  
  output$map <- renderLeaflet({
    labels = with(quakes_subset(), paste0(as.character(time), "<br/>Magnitude ", mag)) %>%
      lapply(HTML)
    
    pal <- colorBin("viridis", earthquakes$mag, bins = 4)
    leaflet(quakes_subset()) %>%
      addTiles() %>%
      addCircleMarkers(radius = ~mag, color = ~pal(mag),
        stroke = FALSE, fillOpacity = 0.7, label = labels) %>%
      addLegend(pal = pal, values = ~earthquakes$mag, opacity = 0.7,
        title = "Magnitude")
  })
}

shinyApp(ui, server)
