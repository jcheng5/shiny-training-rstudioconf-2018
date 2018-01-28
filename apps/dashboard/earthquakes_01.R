library(shiny)
library(ggplot2)
library(leaflet)
library(dplyr)

# From https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.csv
earthquakes <- read.csv("earthquakes.csv", stringsAsFactors = FALSE)
earthquakes$time <- lubridate::parse_date_time(earthquakes$time, orders="ymd HMS")

ui <- fluidPage(
  titlePanel("USGS Earthquake Explorer"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("dates", "Date range",
        start = as.Date(min(earthquakes$time)),
        end = as.Date(max(earthquakes$time)),
        min = as.Date(min(earthquakes$time)),
        max = as.Date(max(earthquakes$time))
      ),
      actionButton("reset_dates", "Reset date range")
    ),
    mainPanel(
      p("Number of quakes:", textOutput("count", inline = TRUE)),
      p("Median magnitude:", textOutput("median", inline = TRUE)),
      p("Mean time between quakes:", textOutput("mtbq", inline = TRUE)),
      leafletOutput("map"),
      plotOutput("scatter"),
      plotOutput("mag_hist")
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
  
  output$count <- renderText({
    nrow(quakes_subset())
  })
  
  output$median <- renderText({
    median(quakes_subset()$mag)
  })
  
  output$mtbq <- renderText({
    by_time <- quakes_subset()
    diffs <- difftime(head(by_time$time, -1), tail(by_time$time, -1), "minutes")
    mtbq <- mean(diffs)
    paste(formatC(mtbq), units(mtbq))
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
  
  output$scatter <- renderPlot({
    ggplot(quakes_subset(), aes(time, mag, color = depth)) +
      geom_point(alpha = 0.4)
  })
  
  output$mag_hist <- renderPlot({
    ggplot(quakes_subset(), aes(mag)) +
      geom_histogram(fill = "#99BBFF")
  })
}

shinyApp(ui, server)
