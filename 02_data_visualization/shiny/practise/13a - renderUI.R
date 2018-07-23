library(shiny)
library(ggplot2)

ui <- shinyUI(fluidPage(
  titlePanel('Demo of renderUI'),
  sidebarLayout(
    sidebarPanel(
      selectInput('dataname',
                  'Select the dataset',
                  choices = c('iris', 'mtcars', 'trees')
                  ),
      helpText('balabalabalabala'),
      uiOutput('vx'),
      uiOutput('vy')
    ),
    mainPanel(
      plotOutput('p')
    )
  )
))


server <-  shinyServer(function(input, output){
  var <- reactive({
    switch(input$dataname,
           'iris' = names(iris),
           'mtcars' = names(mtcars),
           'trees' = names(trees)
           )
  })

  output$vx <- renderUI({
    selectInput('varx', 'Select the xlab', choices = var())
  })

  output$vy <- renderUI({
    selectInput('vary', 'Select the ylab', choices = var())
  })

  
  # 遇到问题，
  
  output$p <- renderPlot({
    # attach(get(input$dataname))
    # plot(x = get(input$varx), 
    #      y = get(input$vary), 
    #      xlab = input$varx,
    #      ylab = input$vary)
    ggplot(get(input$dataname), 
           aes_string(input$varx, input$vary)) + 
      geom_point()
    # ggplot(get(input$dataname),
    #        aes(x = get(input$varx), y = get(input$vary)),
    #        environment = environment()) +
    #   geom_point()
  })
})


shinyApp(ui, server)