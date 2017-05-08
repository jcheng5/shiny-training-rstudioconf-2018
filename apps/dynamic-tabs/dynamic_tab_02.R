library(shiny)

ui <- fluidPage(
  sidebarPanel(
    fileInput("file", "CSV file"),
    textOutput("n_col_report")
  ),
  mainPanel(
    uiOutput("mytabs")  
  )
)

server <- function(input, output, session){
  
  # Load data
  dataset <- reactive({
    req(input$file)
    read.csv(input$file$datapath, stringsAsFactors = FALSE)
  })
  
  # Determine number of columns
  n_col <- reactive({
    ncol(dataset())
  })
  
  # Report number of columns
  output$n_col_report <- renderText({
    paste0("There are ", n_col(), " variables in this dataset.
           So we expect to dynamically create ", n_col(), " tabs.")
  })
  
  # Generate n_col tabs
  output$mytabs = renderUI({
    n_tabs = n_col()
    my_tabs <- lapply(paste("Tab", 1: n_tabs), tabPanel)
    do.call(tabsetPanel, my_tabs)
  })
}

shinyApp(ui, server)
