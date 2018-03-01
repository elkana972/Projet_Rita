library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "CIRAD" ),
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Accueil", tabName = "accueil",icon = icon("home")),
      menuItem("Fiche varietales", tabName = "fiche",   icon = icon("th")),
      menuItem("Aide", tabName = "aide",icon = icon("life-ring")),
      menuItem("Contact", tabName = "contact",icon = icon("question"))
    )
  ),
  dashboardBody( 
    tabItems(
      # First tab content
      tabItem(tabName = "accueil",
              fluidRow(
               
                column(5,tags$iframe( width = "500", height = "500",src = "http://localhost:3838/sample-apps/Projet_Rita/R/carte_sig/" )),
                column(5,tags$iframe( width = "560", height = "500",src = "http://localhost:3838/sample-apps/Projet_Rita/R/choix_zone_esp/" ))
                
                    ),
              
              
              fluidRow()
      ),
      
      # Second tab content
      tabItem(tabName = "fiche",
              h2("fiche")
      ),
      
      tabItem(tabName = "aide",
              h2("aide")
      ),
      tabItem(tabName = "contact",
              h2("contact")
      )
      
    )
  
  ),
  skin = "green"
)