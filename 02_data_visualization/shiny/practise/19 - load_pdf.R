library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel("Demo of load pdf file"),
  sidebarLayout(
    sidebarPanel(
      h4('This is a demo for load pdf file')
    ),
    mainPanel(
      tabsetPanel(
        tabPanel('Reference', 
                 tags$iframe(style = "height:600px; width:800px; scrolling = yes",
                             src = "http://www.rstudio.com/wp-content/uploads/2015/02/shiny-cheatsheet.pdf"),
        tabPanel('Tab2'),
        tabPanel('Tab3')
        )
      )
    )
  )
))


server <- shinyServer(function(input, output){
  
})


shinyApp(ui, server)