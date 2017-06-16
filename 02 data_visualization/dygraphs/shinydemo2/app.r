# load packages -------------------------------------------------------------------
library('dygraphs')
library('xts')

# ui ------------------------------------------------------------------------------
ui = shinyUI(
  fluidPage(
    
    titlePanel(title = 'shiny dypraph demo2'),
    
    sidebarLayout(
      sidebarPanel(
        numericInput('mnum',
                     'predict months:',
                     value = 72,
                     min = 12,
                     max = 144,
                     step = 12),
        selectInput('interval',
                    'predict interval',
                    choices = c('0.80', '0.90', '0.95', '0.99'),
                    selected = '0.95'),
        checkboxInput('showgrid',
                      'show grid',
                      value = FALSE),
        hr(),
        div(strong('From:'), textOutput('from', inline = TRUE)),
        div(strong('To:'), textOutput('to', inline = TRUE)),
        div(strong('Date clicked:'), textOutput('clicked', inline = TRUE)),
        div(strong('Nearest point clicked:'), textOutput('point', inline = TRUE)),
        br(),
        helpText('Click and drag to zoom in (double click to zoom back out).')
      ),
      mainPanel(dygraphOutput('dygraphdemo'))
    )
  )
)

# server -------------------------------------------------------------------------
server = shinyServer(function(input, output){
  predicted <- reactive({
    hw <- HoltWinters(ldeaths)
    predict(hw, 
            n.ahead = input$mnum,
            prediction.interval = TRUE,
            level = as.numeric(input$interval))
  })
  
  output$dygraphdemo <- renderDygraph({
    dygraph(predicted(), 
            main = 'This is title') %>% 
      dySeries(c('lwr', 'fit', 'upr'), label = 'Deaths') %>% 
      dyAxis('x', drawGrid = input$showgrid) %>% 
      dyRangeSelector()
  })
  
  output$from <- renderText({
    strftime(req(input$dygraphdemo_date_window[[1]]), "%Y-%m-%d")      
  })
  
  output$to <- renderText({
    strftime(req(input$dygraphdemo_date_window[[2]]), "%Y-%m-%d")
  })
  
  output$clicked <- renderText({
    strftime(req(input$dygraphdemo_click$x), "%Y-%m-%d")
  })
  
  output$point <- renderText({
    paste0('X = ', strftime(req(input$dygraphdemo_click$x_closest_point), "%Y-%m-%d"), 
           '; Y = ', req(input$dygraphdemo_click$y_closest_point))
  })
})

shinyApp(ui, server)



























