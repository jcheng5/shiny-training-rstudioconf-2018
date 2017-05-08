library(shiny)
library(ggplot2)
library(DT)
library(stringr)
library(dplyr)
library(tools)
load("movies.Rdata")

# Define UI for application that plots features of movies ---------------------
ui <- fluidPage(
  
  # Application title ---------------------------------------------------------
  titlePanel("Movie browser"),
  
  # Sidebar layout with a input and output definitions ------------------------
  sidebarLayout(
    
    # Inputs: Select variables to plot ----------------------------------------
    sidebarPanel(
      
      # Select variable for y-axis --------------------------------------------
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis --------------------------------------------
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "critics_score"),
      
      # Show data table -------------------------------------------------------
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE),
      
      # Horizontal line for visual separation ---------------------------------
      hr(),
      
      # Select which types of movies to plot ----------------------------------
      checkboxGroupInput(inputId = "selected_type",
                         label = "Select movie type(s):",
                         choices = c("Documentary", "Feature Film", "TV Movie"),
                         selected = "Feature Film"),
      
      # Select sample size ----------------------------------------------------
      numericInput(inputId = "n_samp", 
                   label = "Sample size:", 
                   min = 1, max = nrow(movies), 
                   value = 10),
      
      # Get a new sample ------------------------------------------------------
      actionButton(inputId = "get_new_sample", 
                   label = "Get new sample")
      
    ),
    
    # Output: -----------------------------------------------------------------
    mainPanel(
      
      # Show scatterplot ------------------------------------------------------
      plotOutput(outputId = "scatterplot"),
      HTML("<br>"),        # a little bit of visual separation
      
      # Print number of obs plotted -------------------------------------------
      textOutput(outputId = "n"),
      HTML("<br><br>"),    # a little bit of visual separation
      
      # Show data table -------------------------------------------------------
      dataTableOutput(outputId = "moviestable")
    )
  )
)

# Define server function required to create the scatterplot -------------------
server <- function(input, output, session) {
  
  # Create a subset of data filtering for selected title types ----------------
  movies_subset <- reactive({
    movies %>%
      filter(title_type %in% input$selected_type)
  })
  
  # Update the maximum allowed n_samp for selected type movies ---------------- 
  observe({
    updateNumericInput(session, 
                       inputId = "n_samp", 
                       max = nrow(movies_subset()),
                       value = input$n_samp
    )
  })
  
  # Get new sample ------------------------------------------------------------
  movies_sample <- eventReactive(eventExpr = input$get_new_sample,
                                 valueExpr = {
                                   movies_subset() %>%
                                     sample_n(input$n_samp)
                                 },
                                 ignoreNULL = FALSE
  )
  
  # Create the scatterplot object the plotOutput function is expecting --------
  output$scatterplot <- renderPlot({
    ggplot(data = movies_sample(), aes_string(x = input$x, y = input$y)) +
      geom_point() +
    labs(x = toTitleCase(str_replace_all(input$x, "_", " ")),
         y = toTitleCase(str_replace_all(input$y, "_", " ")),
         color = toTitleCase(str_replace_all(input$z, "_", " "))
    )
  })
  
  # Print number of movies plotted --------------------------------------------
  output$n <- renderText({
    counts <- movies_sample() %>%
      group_by(title_type) %>%
      summarise(count = n()) %>%
      select(count) %>%
      unlist()
    paste("There are", counts, input$selected_type, "movies in this dataset.")
  })
  
  # Print data table if checked -----------------------------------------------
  output$moviestable <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = movies_sample()[, 1:7], 
                    options = list(pageLength = 10), 
                    rownames = FALSE)
    }
  )
  
}

# Run the application ---------------------------------------------------------
shinyApp(ui = ui, server = server)
