library(shiny)
library(ggplot2)
library(DT)
library(stringr)
library(dplyr)
load("movies.Rdata")

# Define UI for application that plots features of movies -----------
ui <- fluidPage(

  # Application title -----------------------------------------------
  titlePanel("Movie browser - without modules"),

  # Sidebar layout with a input and output definitions --------------
  sidebarLayout(

    # Inputs: Select variables to plot ------------------------------
    sidebarPanel(

      # Select variable for y-axis ----------------------------------
      selectInput(inputId = "y",
                  label = "Y-axis:",
                  choices = c("IMDB rating" = "imdb_rating",
                              "IMDB number of votes" = "imdb_num_votes",
                              "Critics Score" = "critics_score",
                              "Audience Score" = "audience_score",
                              "Runtime" = "runtime"),
                  selected = "audience_score"),

      # Select variable for x-axis ----------------------------------
      selectInput(inputId = "x",
                  label = "X-axis:",
                  choices = c("IMDB rating" = "imdb_rating",
                              "IMDB number of votes" = "imdb_num_votes",
                              "Critics Score" = "critics_score",
                              "Audience Score" = "audience_score",
                              "Runtime" = "runtime"),
                  selected = "critics_score"),

      # Select variable for color -----------------------------------
      selectInput(inputId = "z",
                  label = "Color by:",
                  choices = c("Genre" = "genre",
                              "MPAA Rating" = "mpaa_rating",
                              "Critics Rating" = "critics_rating",
                              "Audience Rating" = "audience_rating"),
                  selected = "mpaa_rating"),

      # Set alpha level ---------------------------------------------
      sliderInput(inputId = "alpha",
                  label = "Alpha:",
                  min = 0, max = 1,
                  value = 0.5),

      # Set point size ----------------------------------------------
      sliderInput(inputId = "size",
                  label = "Size:",
                  min = 0, max = 5,
                  value = 2),

      # Show data table ---------------------------------------------
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE)

    ),

    # Output: -------------------------------------------------------
    mainPanel(

      # Show scatterplot --------------------------------------------
      tabsetPanel(id = "movies",
                  tabPanel("Documentaries",
                           plotOutput("scatterplot_doc"),
                           DT::dataTableOutput("moviestable_doc")),
                  tabPanel("Feature Films",
                           plotOutput("scatterplot_features"),
                           DT::dataTableOutput("moviestable_features")),
                  tabPanel("TV Movies",
                           plotOutput("scatterplot_tv"),
                           DT::dataTableOutput("moviestable_tv"))
      )
    )
  )
)

# Define server function required to create the scatterplot ---------
server <- function(input, output, session) {

  # Create subsets for various title types --------------------------
  docs <- reactive({
    filter(movies, title_type == "Documentary")
  })

  features <- reactive({
    filter(movies, title_type == "Feature Film")
  })

  tvs <- reactive({
    filter(movies, title_type == "TV Movie")
  })

  # Scatterplot for docs --------------------------------------------
  output$scatterplot_doc <- renderPlot({
    ggplot(data = docs(), aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_point(alpha = input$alpha, size = input$size) +
      labs(x = toTitleCase(str_replace_all(input$x, "_", " ")),
           y = toTitleCase(str_replace_all(input$y, "_", " ")),
           color = toTitleCase(str_replace_all(input$z, "_", " "))
      )
  })

  # Scatterplot for features ----------------------------------------
  output$scatterplot_feature <- renderPlot({
    ggplot(data = features(), aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_point(alpha = input$alpha, size = input$size) +
      labs(x = toTitleCase(str_replace_all(input$x, "_", " ")),
           y = toTitleCase(str_replace_all(input$y, "_", " ")),
           color = toTitleCase(str_replace_all(input$z, "_", " "))
      )
  })

  # Scatterplot for tvs ---------------------------------------------
  output$scatterplot_tv <- renderPlot({
    ggplot(data = tvs(), aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_point(alpha = input$alpha, size = input$size) +
      labs(x = toTitleCase(str_replace_all(input$x, "_", " ")),
           y = toTitleCase(str_replace_all(input$y, "_", " ")),
           color = toTitleCase(str_replace_all(input$z, "_", " "))
      )
  })

  # Table for docs --------------------------------------------------
  output$moviestable_doc <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = docs()[, 1:7],
                    options = list(pageLength = 10),
                    rownames = FALSE)
    }
  )

  # Table for features ----------------------------------------------
  output$moviestable_feature <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = features()[, 1:7],
                    options = list(pageLength = 10),
                    rownames = FALSE)
    }
  )

  # Table for tvs ---------------------------------------------------
  output$moviestable_tv <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = tvs()[, 1:7],
                    options = list(pageLength = 10),
                    rownames = FALSE)
    }
  )

}

# Run the application -----------------------------------------------
shinyApp(ui = ui, server = server)

