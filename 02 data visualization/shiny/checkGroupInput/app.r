## Only run examples in interactive R sessions
if (interactive()) {
  
  ui <- fluidPage(
    checkboxGroupInput("variable", "Variables to show:",
                       c("Cylinders" = "cyl",
                         "Transmission" = "am",
                         "Gears" = "gear")),
    tableOutput("data")
  )
  
  server <- function(input, output) {
    output$data <- renderTable({
      mtcars[, c("mpg", input$variable), drop = FALSE]
    }, rownames = TRUE)
  }
  
  shinyApp(ui, server)
}