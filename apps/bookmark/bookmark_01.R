library(shiny)

# Define UI for bookmarking demo app --------------------------------
ui <- function(request) {
  fluidPage(
    textInput("txt", "Enter text"),
    checkboxInput("caps", "Capitalize"),
    verbatimTextOutput("out"),
    bookmarkButton()
  )
}

# Define server logic for capitalizing text -------------------------
server <- function(input, output, session) {
  output$out <- renderText({
    ifelse(input$caps, toupper(input$txt), input$txt)
  })
}

# Run the app -------------------------------------------------------
shinyApp(ui, server, enableBookmarking = "url")
