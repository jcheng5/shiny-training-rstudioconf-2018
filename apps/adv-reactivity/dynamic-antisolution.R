library(shiny)
library(ggplot2)

# Define UI for dynamic UI ------------------------------------------
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "CSV file"),
      uiOutput("field_chooser_ui")
    ),
    mainPanel(
      plotOutput("plot"),
      verbatimTextOutput("summary")
    )
  )
)

# Define server logic for summarizing selected file ------------------
server <- function(input, output, session) {

  # Load data
  full_data <- reactive({
    if (is.null(input$file))
      return(NULL) # Works, but not best practice
    
    read.csv(input$file$datapath, stringsAsFactors = FALSE)
  })
  
  # Subset for specified columns
  subset_data <- reactive({
    if (is.null(full_data()) || is.null(input$xvar) || is.null(input$yvar))
      return(NULL) # Works, but not best practice
    
    full_data()[, c(input$xvar, input$yvar)]
  })
  
  # Dynamic UI for variable names based on selected file
  output$field_chooser_ui <- renderUI({
    if (is.null(full_data()))
      return(NULL) # Works, but not best practice
    
    col_names <- names(full_data())
    tagList(
      selectInput("xvar", "X variable", col_names),
      selectInput("yvar", "Y variable", col_names, selected = col_names[[2]])
    )
  })
  
  # Scatterplot of selected variables
  output$plot <- renderPlot({
    if (is.null(subset_data()))
      return(NULL) # Works, but not best practice
    
    ggplot(subset_data(), aes_string(x = input$xvar, y = input$yvar)) +
      geom_point()
  })
  
  # Summary of selected variables
  output$summary <- renderPrint({
    if (is.null(subset_data()))
      return(invisible()) # Works, but not best practice

    summary(subset_data())
  })
}

# Run the app -------------------------------------------------------
shinyApp(ui, server)
