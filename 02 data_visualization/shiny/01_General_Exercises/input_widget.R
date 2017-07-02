
# library packages ====================================
library(shiny)
library(shinydashboard)

# UI ==================================================
ui <- dashboardPage(
  
  ## dashboardHeader =================================
  dashboardHeader(
    
    title = 'Test header'
  ),
  
  ## dashboardSiderbar ===============================
  dashboardSidebar(
    sidebarMenu(
      
      ### menuitem01 ===================================
      menuItem(
        text = 'input widget', tabName = 'tab01'
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

# Server ==============================================
server <- shinyServer(function(input, output){
  
})


# Run APP =============================================
shinyApp(ui, server)
