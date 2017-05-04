library(shiny)

# Define UI for app with multiple tabs ------------------------------
ui <- function(request) {
  fluidPage(
    tabsetPanel(id = "tabs",
      tabPanel("Tab one",
        checkboxInput("chk1", "Checkbox 1"),
        bookmarkButton(id = "bookmark1")
      ),
      tabPanel("Tab two",
        checkboxInput("chk2", "Checkbox 2"),
        bookmarkButton(id = "bookmark2")
      )
    )
  )
}

# Define server logic for app with multiple tabs and bookmarking ----
server <- function(input, output, session) {
  
  # Need to exclude the buttons from themselves being bookmarked
  setBookmarkExclude(c("bookmark1", "bookmark2"))

  # Trigger bookmarking with either button
  observeEvent(input$bookmark1, {
    session$doBookmark()
  })
  observeEvent(input$bookmark2, {
    session$doBookmark()
  })
}

# Run the app -------------------------------------------------------
shinyApp(ui, server, enableBookmarking = "url")
