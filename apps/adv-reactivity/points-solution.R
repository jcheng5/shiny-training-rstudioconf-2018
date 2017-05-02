library(shiny)

# Define UI for specifying points on a plot -------------------------
ui <- fluidPage(
  plotOutput("plot", click = "click", width = 400),
  verbatimTextOutput("summary")
)

# Define server logic for summarizing selected file ------------------
server <- function(input, output, session) {

  # Use rv$data to track the points clicked so far
  rv <- reactiveValues(data = data.frame(x=numeric(), y=numeric()))
  
  # Handle click events by adding a new row to the rv$data data frame
  observeEvent(input$click, {
    rv$data <- rbind(
      rv$data,
      data.frame(x=input$click$x, y=input$click$y)
    )
  })
  
  # Plot specified points
  output$plot <- renderPlot({
    ggplot(rv$data, aes(x=x, y=y)) + geom_point() +
      xlim(0, 1) + ylim(0, 1)
  })
  
  # Wrap rv$data and ensure that it's not empty
  data <- reactive({
    req(nrow(rv$data) > 0)
    rv$data
  })
  
  # Debounce
  debounced_data <- debounce(data, 1000)
  
  # Summarize data
  output$summary <- renderPrint({
    # Insert artificial slowness
    on.exit(Sys.sleep(1))
    
    print(summary(debounced_data()))
  })
}

# Run the app -------------------------------------------------------
shinyApp(ui, server)
