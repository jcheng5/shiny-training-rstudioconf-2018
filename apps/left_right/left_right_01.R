library(shiny)

# Module 1: Dataset chooser ---------------------------------------------------

# Module 1 UI
dataset_chooser_UI <- function(id) {
  ns <- NS(id)

  tagList(
    selectInput(ns("dataset"), "Choose a dataset", c("pressure", "cars")),
    numericInput(ns("count"), "Number of records to return", 10)
  )
}

# Module 1 Server
dataset_chooser <- function(input, output, session) {
  dataset <- reactive({
    req(input$dataset)
    get(input$dataset, pos = "package:datasets")
  })
  
  return(list(
    dataset = dataset,
    count = reactive(input$count)
  ))
}

# Module 2: Dataset summarizer ------------------------------------------------

# Module 2 UI
dataset_summarizer_UI <- function(id) {
  ns <- NS(id)
  
  verbatimTextOutput(ns("summary"))
}

# Module 2 Server
dataset_summarizer <- function(input, output, session, dataset, count) {
  output$summary <- renderPrint({
    summary(head(dataset(), count()))
  })
}

# App combining Module 1 and Module 2 -----------------------------------------

# App UI
ui <- fluidPage(
  fluidRow(
    column(6,
      dataset_chooser_UI("left_input"),
      dataset_summarizer_UI("left_output")
    ),
    column(6,
      dataset_chooser_UI("right_input"),
      dataset_summarizer_UI("right_output")
    )
  )
)

# App server
server <- function(input, output, session) {
  left_result <- callModule(dataset_chooser, "left_input")
  right_result <- callModule(dataset_chooser, "right_input")
  
  callModule(dataset_summarizer, "left_output", dataset = left_result$dataset, count = left_result$count)
  callModule(dataset_summarizer, "right_output", dataset = right_result$dataset, count = right_result$count)
}

shinyApp(ui, server)