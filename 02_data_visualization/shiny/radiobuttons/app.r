## Only run examples in interactive R sessions
if (interactive()) {
  
  ui <- fluidPage(
    radioButtons("dist", "Distribution type:",
                 c("Normal" = "norm",
                   "Uniform" = "unif",
                   "Log-normal" = "lnorm",
                   "Exponential" = "exp")),
    plotOutput("distPlot")
  )
  
  server <- function(input, output) {
    output$distPlot <- renderPlot({
      dist <- switch(input$dist,
                     norm = rnorm,
                     unif = runif,
                     lnorm = rlnorm,
                     exp = rexp,
                     rnorm)
      
      hist(dist(500))
    })
  }
  
  shinyApp(ui, server)
  
}