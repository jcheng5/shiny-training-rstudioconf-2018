library(shiny)
library(ggplot2)

# Define UI for application demoing UI construction -----------------
ui <- fluidPage(
  fluidRow(
    column(5,
      plotOutput("plot", brush = "brush")
    ),
    column(7,
      tableOutput("detail")
    )
  )
)

# Define server logic for application demoing UI construction -------
server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(x = hp, y = mpg)) +
      geom_point()
  })
  
  output$detail <- renderTable({
    brushed <- brushedPoints(mtcars, input$brush)
    validate(need(nrow(brushed) > 0, "Click and drag to select data points"))
    brushed[, c("mpg", "cyl", "disp", "hp", "wt")]
  }, rownames = TRUE)
}

# Run the app -------------------------------------------------------
shinyApp(ui, server)