# A module that renders a datatable from the DT package.
#
# The server function returns a reactive expression that reflects
# when a user clicks on a row. If `reset`, then the selection is
# cleared as soon as it is registered with the server (i.e. the
# row doesn't stay highlighted in the UI).

tableWithSelectUI <- function(id) {
  ns <- NS(id)
  
  DT::dataTableOutput(ns("table"))
}

#' @param input,output,session Automatically provided by Shiny
#' @param dataset A reactive expression that returns a data frame
#' @param reset If TRUE (the default), clears the selection immediately
#' @param ... Additional arguments to DT::datatable
#' @return A reactive expression that returns the selected row index
tableWithSelect <- function(input, output, session, dataset, reset = TRUE, ...) {
  output$table <- DT::renderDataTable({
    DT::datatable(dataset(), selection = "single", ...)
  })

  if (reset) {
    observeEvent(input$table_rows_selected, {
      # Clear selection
      DT::dataTableProxy("table") %>% selectRows(NULL)
    })
  }
  
  reactive(req(input$table_rows_selected))
}
