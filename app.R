library(shiny)
library(bslib)
library(shinyvalidate)
library(glue)

generate_story <- function(noun, verb, adjective, adverb) {
  glue(
    "
    Welcome to the Ultimate Mad Libs Adventure!

    Deep in the enchanted forest, a {adjective} {noun} dreamed of the day it could {verb} {adverb}.
    One magical morning, it finally happened—and the world was never the same again!

    What will your next story be?
    "
  )
}

ui <- fluidPage(
  theme = bs_theme(bootswatch = "minty", base_font = font_google("Roboto")),
  titlePanel("🌟 Mad Libs Game: Create Your Own Story!"),
  sidebarLayout(
    sidebarPanel(
      helpText("Fill in each blank to create your own silly story!"),
      textInput("noun1", "Enter a noun (person, place, or thing):", ""),
      textInput("verb", "Enter a verb (action word):", ""),
      textInput("adjective", "Enter an adjective (describing word):", ""),
      textInput("adverb", "Enter an adverb (how the action is done):", "")
    ),
    mainPanel(
      h3("Your Mad Libs Story:"),
      verbatimTextOutput("story")
    )
  )
)

server <- function(input, output, session) {
  iv <- InputValidator$new()
  iv$add_rule("noun1", sv_required(message = "Please enter a noun."))
  iv$add_rule("verb", sv_required(message = "Please enter a verb."))
  iv$add_rule("adjective", sv_required(message = "Please enter an adjective."))
  iv$add_rule("adverb", sv_required(message = "Please enter an adverb."))
  iv$enable()

  output$story <- renderText({
    if (!iv$is_valid()) {
      return("Please fill in all fields to see your story!")
    }
    generate_story(input$noun1, input$verb, input$adjective, input$adverb)
  })
}

shinyApp(ui = ui, server = server)
