library(shiny)
library(ggplot2)
library(lubridate)
library(dplyr)
load("soi.Rdata")

soi <- soi %>%
  mutate(
    date = ymd(paste0(date, "01")),
    year = year(date),
    month = month(date),
    date_for_plot = year + (month / 12)
  )

# Define UI for application that plots features of movies ---------------------
ui <- basicPage(
  plotOutput("zoom", height = "350px"),
  plotOutput("overall", height = "150px",
             brush =  brushOpts(id = "brush", direction = "x")
  )
)

# Define server function required to create the scatterplot -------------------
server <- function(input, output) {
  
  p <- ggplot(data = soi, aes(x = date_for_plot, y = value)) +
    geom_point(size = 0.8) +
    geom_line(lwd = 0.3) +
    theme_bw() +
    geom_hline(yintercept = 0, color = "orange", lty = 2) +
    labs(y = "SOI", x = "Date")
  
  output$zoom <- renderPlot({
    if (!is.null(input$brush)) {
      p <- p + 
        xlim(input$brush$xmin, input$brush$xmax) +
        labs(title = "Southern Oscillation Index (SOI)")
    }
    p
  })
  
  output$overall <- renderPlot(p)
  
}

# Run the application ---------------------------------------------------------
shinyApp(ui = ui, server = server)
