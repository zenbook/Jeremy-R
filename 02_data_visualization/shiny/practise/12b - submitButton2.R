library(shiny)
library(datasets)

ui <- shinyUI(
  fluidPage(
    titlePanel('Another demo of submitButton'),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          'dataname', 
          'Select the dataset name',
          choices = c('iris', 'mtcars', 'pressure')
        ),
        numericInput('obs', 'Number of observations:', 6),
        submitButton('Update!')
      ),
      mainPanel(
        h4(textOutput('dataname')),
        verbatimTextOutput('structure'),
        h4(textOutput('observations')),
        tableOutput('view')
      )
    )
  )
)


server <- shinyServer(function(input, output){
    
  output$dataname <- renderText({
    paste('Structure of dataset:', input$dataname)
  })
  
  output$observations <- renderText({
    paste('First', input$obs, 'observations of dataset:', input$dataname)
  })
  
  output$structure <- renderPrint({
    str(get(input$dataname))
  })
  
  output$view <- renderTable({
    head(get(input$dataname), n = input$obs)
  })
})


shinyApp(ui, server)