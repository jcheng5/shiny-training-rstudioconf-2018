library(shiny)

ui <- fluidPage(
  sidebarPanel(
    numericInput("nTabs", 'No. of Tabs', 5)
  ),
  mainPanel(
    uiOutput('mytabs')  
  )
)

server <- function(input, output, session){
    output$mytabs = renderUI({
      nTabs = input$nTabs
      myTabs = lapply(paste('Tab', 1: nTabs), tabPanel)
      do.call(tabsetPanel, myTabs)
    })
}

shinyApp(ui, server)
