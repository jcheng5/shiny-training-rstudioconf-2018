#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that adds 2 to a selected value
ui <- fluidPage(
  # Application title
  titlePanel("Add 2"),
  # Sidebar with a slider input for x
  sidebarLayout(
    sidebarPanel( sliderInput("x", "Select x", min = 1, max = 50, value = 30) ),
    mainPanel( textOutput("x_updated") )
  )
)

# Define server logic
server <- function(input, output) {
  add_2            <- function(x) { x + 2 }
  #current_x        <- add_2(input$x)
  #output$x_updated <- renderText({ current_x })
  current_x <- reactive({ add_2(input$x) })
  output$x_updated <- renderText({ current_x() })
}

# Run the application 
shinyApp(ui = ui, server = server)

