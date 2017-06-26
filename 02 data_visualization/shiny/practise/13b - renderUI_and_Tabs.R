library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel('Demo of renderUI and multiple tabs'),
  sidebarLayout(
    sidebarPanel(
      numericInput('tabnum', 'Enter the tab numbers you need', 1)
    ),
    mainPanel(
      uiOutput('tabs')
    )
  )
))

server <- shinyServer(function(input, output){
  output$tabs <- renderUI({
    Tabs <- lapply(paste('tab no.', 1:input$tabnum, sep = ' '), tabPanel)
    do.call(tabsetPanel, Tabs)
  })
})

shinyApp(ui, server)