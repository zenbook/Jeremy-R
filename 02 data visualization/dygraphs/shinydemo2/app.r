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
        
      )
    )
  )
)