library(shiny)

ui <- shinyUI(
  fluidPage(
    titlePanel('Demo of submitButton'),
    sidebarLayout(
      sidebarPanel(
        textInput('text1', 'Enter your first name'),
        textInput('text2', 'Enter your last name'),
        submitButton('Update!'),
        p('click on the Update button to display the first and last name')
      ),
      mainPanel(
        textOutput('text1'),
        textOutput('text2')
      )
    )
  )
)

server <- shinyServer(
  function(input, output){
    output$text1 <- renderText({
      paste('My first name is:', input$text1)
    })
    output$text2 <- renderText({
      paste('My last naem is:', input$text2)
    })
  }
)

shinyApp(ui, server)

