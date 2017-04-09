# load packages -------------------------------------------------------------------
library('dygraphs')

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
        div(strong('To:'), textOutput('To', inline = TRUE)),
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
      dyAxis('x', drawGrid = input$showgrid)
  })
  
  output$from <- renderText({
    strftime(req(input$dygraph_date_window[[1]]), "%d %b %Y")      
  })
  
  output$to <- renderText({
    strftime(req(input$dygraph_date_window[[2]]), "%d %b %Y")
  })
  
  output$clicked <- renderText({
    strftime(req(input$dygraph_click$x), "%d %b %Y")
  })
  
  output$point <- renderText({
    paste0('X = ', strftime(req(input$dygraph_click$x_closest_point), "%d %b %Y"), 
           '; Y = ', req(input$dygraph_click$y_closest_point))
  })
})

shinyApp(ui, server)



























