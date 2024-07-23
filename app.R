library(shiny)

story_templates <- list(
)

ui <- fluidPage(
  titlePanel("Mad Libs Game featuring Joe Cheng and Winston Chang"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("noun", "Enter a noun:", ""),
      textInput("noun2", "Enter another noun:", ""),
      textInput("verb", "Enter a verb:", ""),
      textInput("verb2", "Enter another verb:", ""),
      textInput("adjective", "Enter an adjective:", ""),
      textInput("adjective2", "Enter another adjective:", ""),
      textInput("adverb", "Enter an adverb:", ""),
      actionButton("submit", "Create Story")
    ),
    
    mainPanel(
      h3("Your Mad Libs Story:"),
      textOutput("story")
    )
  )
)

generate_story <- function(adjective, verb, adverb, noun, adjective2, noun2, verb2) {

  glue::glue("
    Once upon a time, Joe Cheng and Winston Chang were working on a
    {adjective} Shiny app. They decided to {verb} it {adverb} so that everyone 
    could enjoy using it. One day, Joe suggested they add a {noun} to the app, 
    which made it even more {adjective2}. Winston agreed and also added 
    {noun2}. Together, they {verb2} and created the best Shiny app ever!
  ")
}

ui <- fluidPage(
  titlePanel("Mad Libs Game"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("noun", "Enter a singular computer noun:", ""),
      textInput("noun2", "Enter a plural computer noun:", ""),
      textInput("verb", "Enter a present tense verb:", ""),
      textInput("verb2", "Enter a past tense verb:", ""),
      textInput("adjective", "Enter negative adjective:", ""),
      textInput("adjective2", "Enter positive adjective:", ""),
      textInput("adverb", "Enter an adverb:", ""),
      actionButton("submit", "Create Story")
    ),
    
    mainPanel(
      h3("Your Mad Libs Story:"),
      textOutput("story")
    )
  )
)

server <- function(input, output) {
  
  story <- eventReactive(input$submit, {
    generate_story(    
      noun = input$noun,
      noun2 = input$noun2,
      verb = input$verb,
      verb2 = input$verb2,
      adjective = input$adjective,
      adjective2 = input$adjective2,
      adverb = input$adverb
)
  })
  
  output$story <- renderText({
    story()
  })
}

shinyApp(ui = ui, server = server)

