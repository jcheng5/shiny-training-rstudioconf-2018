library(shiny)

# Define UI for bookmarking demo app --------------------------------
ui <- function(request) {
  fluidPage(
    sliderInput("slider", "Add a value:", 0, 100, 0),
    h4("Sum of all previous slider values: "),
    verbatimTextOutput("sum"),
    bookmarkButton()
  )
}


# Define server logic for bookmarking demo app ----------------------
server <- function(input, output) {
  vals <- reactiveValues(s = 0)

  observe({
   vals$s <- isolate(vals$s) + input$slider
  })

  output$sum <- renderText({
    vals$s
  })

  # Save extra values in state$values when we bookmark...
  onBookmark(function(state) {
    state$values$s <- vals$s
  })
  # Restore extra values from state$values when we restore
  onRestore(function(state) {
    vals$s <- state$values$s
  })
  setBookmarkExclude("slider")

}

# Run the app -------------------------------------------------------
shinyApp(ui, server, enableBookmarking = "url")
