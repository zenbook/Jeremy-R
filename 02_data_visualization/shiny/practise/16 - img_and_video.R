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
                   selected = ','),
      h6('Powered by:'),
      tags$img(src = 'RStudio-Logo-Blue-Gray-250.png', height = 50, width = 120)
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
    if(is.null(data()))
      h4('intro video about dplyr',
         br(),
         tags$video(src = 'R-dplyr-select.mp4', 
                    type = 'video/mp4', 
                    height = '250px', 
                    width = '350px', 
                    controls = 'controls')
      )
    else
      tabsetPanel(tabPanel('About file', tableOutput('filedf')), 
                  tabPanel('Summary', tableOutput('sum')), 
                  tabPanel('Data', tableOutput('datatable'))
                  )
  })
})


shinyApp(ui, server)