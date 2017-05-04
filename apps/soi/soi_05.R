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
  fluidRow(
    column(width = 6,
           plotOutput("scatterplot",
                      brush = brushOpts(id = "brush")
           )
    ),
    column(width = 6,
           plotOutput("histgram")
    )
  )
)

# Define server function required to create the scatterplot -------------------
server <- function(input, output) {
  
  output$scatterplot <- renderPlot({
    ggplot(data = soi, aes(x = date_for_plot, y = value)) +
      geom_point(size = 0.8) +
      geom_line(lwd = 0.3) +
      theme_bw() +
      geom_hline(yintercept = 0, color = "orange", lty = 2) +
      labs(title = "Southern Oscillation Index (SOI)",
           y = "SOI", x = "Date")
  })
  
  output$histgram <- renderPlot({
    brushed <- brushedPoints(soi, input$brush)
    ggplot(soi, aes(x = value)) +
      geom_histogram(border = "white") +
      geom_histogram(data = brushed, fill = "orange") +
      theme_bw() +
      labs(x = "SOI", title = "Histogram of SOI")
  })
  
}

# Run the application ---------------------------------------------------------
shinyApp(ui = ui, server = server)
