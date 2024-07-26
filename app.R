library(shiny)
library(shinyvalidate)
library(duckdb)

ui <- fluidPage(
  titlePanel("Mad Libs Game"),
  p("Fill in the blanks to create a story! Your results will be saved in my database"),
  
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

generate_story <- function(adjective, verb, adverb, noun, adjective2, noun2, verb2) {
  glue::glue("
    Once upon a time, Joe Cheng and Winston Chang were working on a
    {adjective} Shiny app. They decided to {verb} it {adverb} so that everyone 
    could enjoy using it. One day, Joe suggested they add a {noun} to the app, 
    which made it even more {adjective2}. Winston agreed and also added 
    {noun2}. Together, they {verb2} and created the best Shiny app ever!
  ")
}

add_row_to_db <- function(noun, noun2, verb, verb2, adjective, adjective2, adverb) {
  cat("Connecting to database\n")
  con <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(con))
  
  DBI::dbExecute(con, "ATTACH 'md:'")
  cat("Appending row\n")
  DBI::dbAppendTable(con, DBI::SQL("my_db.mad_libs"), data.frame(
    noun = noun,
    noun2 = noun2,
    verb = verb,
    verb2 = verb2,
    adjective = adjective,
    adjective2 = adjective2,
    adverb = adverb,
    timestamp = Sys.time()
  ))
  invisible()
}
server <- function(input, output) {
  iv <- InputValidator$new()
  iv$add_rule("noun", sv_required())
  iv$add_rule("noun2", sv_required())
  iv$add_rule("verb", sv_required())
  iv$add_rule("verb2", sv_required())
  iv$add_rule("adjective", sv_required())
  iv$add_rule("adjective2", sv_required())
  iv$add_rule("adverb", sv_required())
  iv$enable()

  story <- eventReactive(input$submit, {
    req(iv$is_valid())
    cat("Processing submit\n")
    try(add_row_to_db(
      noun = input$noun,
      noun2 = input$noun2,
      verb = input$verb,
      verb2 = input$verb2,
      adjective = input$adjective,
      adjective2 = input$adjective2,
      adverb = input$adverb
    ))
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
