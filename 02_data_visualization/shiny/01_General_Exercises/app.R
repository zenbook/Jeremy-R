
# library packages and data ===============================================
library(shiny)
library(shinydashboard)
library(tidyverse)


# UI ======================================================================
ui <-  dashboardPage(
  
  ## dashboardHeader =================================
  dashboardHeader(
    title = "Neo's dashboard"
  ),
  
  ## dashboardSiderbar ===============================
  dashboardSidebar(
    sidebarMenu(
      
      ### menuitem01 ===================================
      menuItem(
        text = 'tabItem01', tabName = 'tab01'
      ),
      ### menuitem02 ===================================
      menuItem(
        text = 'tabItem02', tabName = 'tab02'
      )
    )
  ), 
  
  ## dashboardBody ===================================
  dashboardBody(
    tabItems(
      tabItem(
        tabName = 'tab01'
      ),
      tabItem(
        tabName = 'tab02'
      )
    )
  )
)
# Server ==================================================================
server <-  function(input, output){
  
}

# Run APP =================================================================
shinyApp(ui, server)
