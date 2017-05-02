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
  output$value <- renderText({
    0
  })
}

# Run the app -------------------------------------------------------
shinyApp(ui, server)
