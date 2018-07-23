
# loading packages and data ==============================================================================================================
library('shiny')
library('shinydashboard')

# UI =====================================================================================================================================
ui <- dashboardPage(
  
  ## dashboardHeader =================================
  dashboardHeader(
    
    title = 'JollyChic.com'
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

# SERVER =================================================================================================================================
server <- function(input, output){
  
}

# run shinyApp ===========================================================================================================================
shinyApp(ui, server)
