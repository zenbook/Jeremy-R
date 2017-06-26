library(shiny)

# use the code below to set maxrequestsize
# options(shiny.maxRequestSize = 9*1024^2)

ui <- shinyUI(fluidPage(
  titlePanel('Demo of upload file'),
  sidebarLayout(
    sidebarPanel(
      fileInput('datafile', 
                'Select file to upload',
                multiple = FALSE
                ),
      helpText('Default max size is 5MB.'),
      tags$hr(),
      h5(helpText('Check the parameters to be used or not')),
      checkboxInput('header', 'Header', value = TRUE),
      checkboxInput('stringasfactors', 'stringAsFactors', value = FALSE),
      br(),
      radioButtons('sep', 'Seperators', 
                   choices = c(Comma = ',', Semicolon = ';', Tab = '\t', Space = ' '), 
                   selected = ',')
    ),
    mainPanel(
      uiOutput('tb')
    )
  )
))


server <- shinyServer(function(input, output){
  data <- reactive({
    file <- input$datafile
    if(is.null(file)){return()}
    read.table(file = file$datapath, 
               sep = input$sep, 
               header = input$header, 
               stringsAsFactors = input$stringasfactors
               )
  })
  
  output$filedf <- renderTable({
    if(is.null(data())){return()}
    input$datafile
  })
  
  output$sum <- renderTable({
    if(is.null(data())){return()}
    summary(data())
  })
  
  output$datatable <- renderTable({
    if(is.null(data())){return()}
    data()
  })
  
  output$tb <- renderUI({
    if(is.null(data())){return()}
    else
      tabsetPanel(tabPanel('About file', tableOutput('filedf')), 
                  tabPanel('Summary', tableOutput('sum')), 
                  tabPanel('Data', tableOutput('datatable'))
                  )
  })
})


shinyApp(ui, server)