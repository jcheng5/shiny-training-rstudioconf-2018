# Module UI -------------------------------------------------------------------
movies_module_UI <- function(id) {
  ns <- NS(id)
  
  tagList(
    plotOutput(ns("scatterplot")),
    dataTableOutput(ns("moviestable"))
  )
  
}

# Module server ---------------------------------------------------------------
movies_module <- function(input, output, session, data, mov_title_type, x, y, z, alpha, size, show_data) {
  
  # Select movies with given title type ----------------------------------------
  movies_with_type <- reactive({
    filter(data, title_type == as.character(mov_title_type))
  })
  
  # Create the scatterplot object the plotOutput function is expecting --------
  output$scatterplot <- renderPlot({
    ggplot(data = movies_with_type(), aes_string(x = x(), y = y(), color = z())) +
      geom_point(alpha = alpha(), size = size()) +
      labs(x = toTitleCase(str_replace_all(x(), "_", " ")),
           y = toTitleCase(str_replace_all(y(), "_", " ")),
           color = toTitleCase(str_replace_all(z(), "_", " "))
      )
  })
  
  # Print data table if checked -----------------------------------------------
  output$moviestable <- DT::renderDataTable(
    if(show_data()){
      DT::datatable(data = movies_with_type()[, 1:7], 
                    options = list(pageLength = 10), 
                    rownames = FALSE)
    }
  )
  
}