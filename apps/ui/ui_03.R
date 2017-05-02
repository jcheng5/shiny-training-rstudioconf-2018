library(shiny)

# Define UI for YouTube player --------------------------------------
ui <- fluidPage(
  includeHTML("youtube_thumbnail.html")
)

# Define server logic -----------------------------------------------
server <- function(input, output, session) {
  
}

# Run the app -------------------------------------------------------
shinyApp(ui, server)
