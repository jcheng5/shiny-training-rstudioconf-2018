library(shiny)

# Define UI for app that draws a histogram and overlays median ------
ui <- fluidPage(
  # Application title
  titlePanel("Histogram and median"),
  # Sidebar with a slider input for n
  sidebarLayout(
    sidebarPanel( sliderInput("n", "Select n", min = 1, max = 50, value = 30) ),
    mainPanel( 
      plotOutput("hist"),
      textOutput("med")
    )
  )
)

# Define server logic -----------------------------------------------
server <- function(input, output) {
  dist <- reactive({ rnorm(input$n) })
  med  <- reactive({ median(dist()) })
  output$hist <- renderPlot({
    hist(dist())
    #med <- reactive({ median(dist()) })
    abline(v = med(), col = "red")
  })
  output$med <- renderText({
    paste("The median is", round(med(), 3))
  })
}

# Run the app -------------------------------------------------------
shinyApp(ui = ui, server = server)

