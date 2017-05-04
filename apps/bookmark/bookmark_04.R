library(shiny)

# Define UI for accumulator app -------------------------------------
ui <- function(request) {
  fluidPage(
    sidebarPanel(
      sliderInput("n", "Value to add", min = 0, max = 100, value = 50),
      actionButton("add", "Add"), br(), br(),
      bookmarkButton()
    ),
    mainPanel(
      h4("Sum:", textOutput("sum"))
    )
  )
}

# Define server accumulator app with bookmarking --------------------
server <- function(input, output, session) {
  vals <- reactiveValues(sum = 0)
  
  onBookmark(function(state) {
    state$values$currentSum <- vals$sum
  })
  onRestore(function(state) {
    vals$sum <- state$values$currentSum
  })

  observeEvent(input$add, {
    vals$sum <- vals$sum + input$n
  })
  output$sum <- renderText({
    vals$sum
  })
}

# Run the app -------------------------------------------------------
shinyApp(ui, server, enableBookmarking = "url")
