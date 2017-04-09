# load packages ---------------------------------------------------------------------
library('shiny')
library('dygraphs')
  
# ui ------------------------------------------------------------------------------
ui = shinyUI(
  fluidPage(
    
    titlePanel(
      title = 'demo about dygraphs'
    ),
    
    sidebarLayout(
      
      sidebarPanel(
        numericInput('mnum', 
                     'select predict months:', 
                     value = 72, 
                     min = 12,
                     max = 144,
                     step = 12),
        selectInput('interval', 
                    'select predict interval:',
                    choices = c('0.80', '0.90', '0.95', '0.99'),
                    selected = '0.95'),
        checkboxInput('showgrid', 
                      'Show Grid',
                      value = TRUE)
      ),
      
      mainPanel(
        dygraphOutput('dygraphdemo')
      )
    )
  )
)

# server -------------------------------------------------------------------------
server = shinyServer(function(input, output){
  predicted <- reactive({
    hw = HoltWinters(ldeaths)
    predict(hw, 
            n.ahead = input$mnum,
            prediction.interval = TRUE,
            level = as.numeric(input$interval))
  })
  
  output$dygraphdemo <- renderDygraph({
    dygraph(predicted(), 
            main = 'THIS IS TITLE') %>% 
      dySeries(c('lwr', 'fit', 'upr'), label = 'Deaths') %>% 
      dyAxis('x', drawGrid = input$showgrid)
  })
  
})

shinyApp(ui, server)



























