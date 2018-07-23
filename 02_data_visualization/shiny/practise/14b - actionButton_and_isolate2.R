library(shiny)
library(datasets)

ui <- shinyUI(fluidPage(
  titlePanel('Demo of actionButton and isolate() in shiny'),
  sidebarLayout(
    sidebarPanel(
      selectInput('dataset', 
                  'Select the dataset',
                  choices = c('iris', 'pressure', 'mtcars')
                  ),
      numericInput('obs', 'Enter the number of observations', 6),
      
      actionButton('act', 'Update the information')
    ),
    mainPanel(
      h4(textOutput('dataset')),
      verbatimTextOutput('structure'),
      h4(textOutput('observations')),
      tableOutput('view')
    )
  )
))


server <- shinyServer(function(input, output){
  
  output$dataset <- renderText({
    input$act
    isolate(paste('The structure of dataset ', input$dataset))
  })
  
  output$structure <- renderPrint({
    input$act
    isolate(str(get(input$dataset)))
  })
  
  output$observations <- renderText({
    input$act
    isolate(paste('First', input$obs, 'observations of dataset', input$dataset))
  })
  
  output$view <- renderTable({
    input$act
    isolate(head(get(input$dataset), n = input$obs))
  })
})


shinyApp(ui, server)