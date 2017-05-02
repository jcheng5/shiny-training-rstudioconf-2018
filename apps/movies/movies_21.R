#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(DT)
library(stringr)
library(tools)
library(dplyr)
load("movies.Rdata")
source("moviesmodule.R")

# Define UI for application that plots features of movies ---------------------
ui <- fluidPage(
  
  # Application title ---------------------------------------------------------
  titlePanel("Movie browser - with modules"),
  
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
      
      # Select variable for color ---------------------------------------------
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Genre" = "genre",
                              "MPAA Rating" = "mpaa_rating", 
                              "Critics Rating" = "critics_rating", 
                              "Audience Rating" = "audience_rating"),
                  selected = "mpaa_rating"),
      
      # Set alpha level -------------------------------------------------------
      sliderInput(inputId = "alpha", 
                  label = "Alpha:", 
                  min = 0, max = 1, 
                  value = 0.5),
      
      # Set point size --------------------------------------------------------
      sliderInput(inputId = "size", 
                  label = "Size:", 
                  min = 0, max = 5, 
                  value = 2),
      
      # Show data table -------------------------------------------------------
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE)
      
    ),
    
    # Output: -----------------------------------------------------------------
    mainPanel(
      
      # Show scatterplot ------------------------------------------------------
      tabsetPanel(id = "movies", 
                  tabPanel("Documentaries", movies_module_UI("doc")),
                  tabPanel("Feature Films", movies_module_UI("feature")),
                  tabPanel("TV Movies", movies_module_UI("tv"))
      )
      
    )
  )
)

# Define server function required to create the scatterplot -------------------
server <- function(input, output, session) {
  
  x     <- reactive(input$x)
  y     <- reactive(input$y)
  z     <- reactive(input$z)
  alpha <- reactive(input$alpha)
  size  <- reactive(input$size)
  show_data <- reactive(input$show_data)
  
  # Create the scatterplot object the plotOutput function is expecting --------
  callModule(movies_module, "doc", data = movies, mov_title_type = "Documentary", x, y, z, alpha, size, show_data)
  callModule(movies_module, "feature", data = movies, mov_title_type = "Feature Film", x, y, z, alpha, size, show_data)
  callModule(movies_module, "tv", data = movies, mov_title_type = "TV Movie", x, y, z, alpha, size, show_data)
  
}

# Run the application ---------------------------------------------------------
shinyApp(ui = ui, server = server)

