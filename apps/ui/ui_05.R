library(shiny)

# Define function that takes a YouTube URL,title, and description ---
# and returns a thumbnail frame
videoThumbnail <- function(videoUrl, title, description) {
  div(class = "thumbnail",
    div(class = "embed-responsive embed-responsive-16by9",
      tags$iframe(class = "embed-responsive-item", src = videoUrl, allowfullscreen = NA)
    ),
    div(class = "caption",
      h3(title),
      div(description)
    )
  )
}

# Define UI for YouTube player --------------------------------------
ui <- fluidPage(
  h1("Random videos"),
  fluidRow(
    column(6,
      videoThumbnail("https://www.youtube.com/embed/hou0lU8WMgo",
        "You are technically correct",
        "The best kind of correct!"
      )
    ),
    column(6,
      videoThumbnail("https://www.youtube.com/embed/4F4qzPbcFiA",
        "Admiral Ackbar",
        "It's a trap!"
      )
    )
  )
)

# Define server logic -----------------------------------------------
server <- function(input, output, session) {
  
}

# Run the app -------------------------------------------------------
shinyApp(ui, server)
