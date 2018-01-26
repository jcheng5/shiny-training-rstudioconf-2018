library(shiny)

# Define function that takes a YouTube URL,title, and description ---
# and returns a thumbnail frame, implemented using a template
videoThumbnail <- function(videoUrl, title, description) {
  htmltools::htmlTemplate("youtube_thumbnail_template.html",
    videoUrl = videoUrl,
    title = title,
    description = description)
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
