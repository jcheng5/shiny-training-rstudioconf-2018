library(shiny)

# Define UI for counter ---------------------------------------------
ui <- fluidPage(
  actionButton("increment", "Increment"),
  actionButton("decrement", "Decrement"),
  actionButton("reset", "Reset"),
  
  p(
    textOutput("value")
  )
)

# Define server logic -----------------------------------------------
server <- function(input, output, session) {
  rv <- reactiveValues(count = 0)
  
  observeEvent(input$increment, {
    rv$count <- rv$count + 1
  })
  observeEvent(input$decrement, {
    rv$count <- rv$count - 1
  })
  observeEvent(input$reset, {
    rv$count <- 0
  })
  
  output$value <- renderText({
    rv$count
  })
}

# Run the app -------------------------------------------------------
shinyApp(ui, server)
