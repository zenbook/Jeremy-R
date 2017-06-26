library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel('Demo of actionButton and isolate'),
  sidebarLayout(
    sidebarPanel(
      textInput('firstname', 'Enter your first name'),
      textInput('lastname', 'Enter your last name'),
      actionButton('act1', 'Update last name!')
    ),
    mainPanel(
      textOutput('firstname'),
      textOutput('lastname')
    )
  )
))

server <- shinyServer(function(input, output){
  output$firstname <- renderText({
    paste('My first name is:', input$firstname)
  })
  
  output$lastname <- renderText({
    input$act1
    isolate(paste('My last name is:', input$lastname))
  })
})


shinyApp(ui, server)