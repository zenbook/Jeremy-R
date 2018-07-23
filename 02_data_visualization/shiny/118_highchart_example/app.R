
# loading packages and data --------------------------------------------------------------------------------------------------------------
library('shiny')
library('dplyr')
library('tidyr')
library('highcharter')
births <- read.csv('births.csv')
years <- unique(births$year)

# UI -------------------------------------------------------------------------------------------------------------------------------------
ui <- fluidPage(
  
  ## App title ---------------------------------
  titlePanel(
    'This is the title'
  ),
  
  ## sidebar layout with a input and output ----
  sidebarLayout(
    
    ### input ----------------------------------
    sidebarPanel(
      sliderInput('year',
                  label = 'year',
                  min = min(years),
                  max = max(years),
                  step = 1,
                  sep = '',
                  value = range(years)
      ),
      selectInput('plot_type',
                  label = 'plot type',
                  choices = c("Scatter" = "scatter", 
                              "Bar" = "column", 
                              "Line" = "line")
      ),
      selectInput('theme',
                  label = 'Theme',
                  choices = c("No theme", 
                              "Chalk" = "chalk",
                              "Dark Unica" = "darkunica", 
                              "Economist" = "economist",
                              "FiveThirtyEight" = "fivethirtyeight", 
                              "Gridlight" = "gridlight", 
                              "Handdrawn" = "handdrawn", 
                              "Sandsignika" = "sandsignika")
      )
    ),
    
    ### output ---------------------------------
    mainPanel(
      highchartOutput('hccontainer', height = '500px')
    )
  )
)

# SERVER ---------------------------------------------------------------------------------------------------------------------------------
server <- function(input, output){
  
  ## calculate diff ----------------------------
  diff13 <- reactive({
    births %>% 
      filter(between(year, input$year[1], input$year[2])) %>% 
      filter(date_of_month %in% c(6, 13, 20)) %>% 
      mutate(day = ifelse(date_of_month == 13, 'thirteen', 'not_thirteen')) %>% 
      group_by(day_of_week, day) %>% 
      summarise(mean_births = mean(births)) %>% 
      arrange(day_of_week) %>% 
      spread(day, mean_births) %>% 
      mutate(diff_ppt = ((thirteen - not_thirteen) / not_thirteen) * 100)
  })
  
  ## input year range --------------------------
  year_range <- reactive({
    if(input$year[1] == input$year[2]){
      as.character(input$year[1])
    }
    else{paste(input$year[1], " - ", input$year[2])}
  })
  
  ## plot highchater ---------------------------
  output$hccontainer <- renderHighchart({
    
    hc <- highchart() %>% 
      hc_add_series(
        data = diff13()$diff_ppt,
        type = input$plot_type,
        name = "Difference, in ppt",
        showInLegend = FALSE
      ) %>% 
      hc_yAxis(title = list(text = "Difference, in ppt"), 
               allowDecimals = FALSE) %>%
      hc_xAxis(
        categories = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"),
        tickmarkPlacement = "on",
        opposite = TRUE
      ) %>% 
      hc_title(
        text = 'The Friday the 13th effect',
        style = list(fontWeight = 'bold')
      ) %>% 
      hc_subtitle(
        text = paste('Difference in the share of U.S. births on 13th 
                     of each month from the average of births on the 6th 
                     and the 20th,',
                     year_range())
      ) %>% 
      hc_tooltip(
        valueDecimals = 4, 
        pointFormat = "Diff:{point.y}"
      )
      
    ### theme ----------------------------------
    if(input$theme != 'No theme'){
      theme <- switch(input$theme, 
                      chalk = hc_theme_chalk(),
                      darkunica = hc_theme_darkunica(),
                      fivethirtyeight = hc_theme_538(),
                      gridlight = hc_theme_gridlight(),
                      handdrawn = hc_theme_handdrawn(),
                      economist = hc_theme_economist(),
                      sandsignika = hc_theme_sandsignika()
        
      )
      hc <- hc %>% 
        hc_add_theme(theme)
    }
    
    ### print highchart ------------------------
    hc
  })
  
}

# run shinyApp ---------------------------------------------------------------------------------------------------------------------------
shinyApp(ui, server)