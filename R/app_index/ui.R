source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/filtre.R")

library(shinydashboard)

zn=array_zone()
esp=array_esp()

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
    shinyjs::useShinyjs(),
    
    tabItems(
      # First tab content
      tabItem(tabName = "accueil",
              #  
              #  # column(5,tags$iframe( width = "500", height = "500",src = "http://localhost:3838/sample-apps/Projet_Rita/R/carte_sig/" )),
              #   # column(8,tags$iframe( width = "860", height = "500",src = "http://localhost:3838/sample-apps/Projet_Rita/R/choix_zone_esp/" ))
              #   # 
              #   #     
              #   
              #   box(
              #     width = 8, height ="530" , status = "info",
              #   
              #     tags$iframe(height = "500",width = "800",src = "http://localhost:3838/sample-apps/Projet_Rita/R/choix_zone_esp/" )
              #   )
              #   
              #   # valueBox(value= "dd", color = "aqua", width = 4,
              #   #          href = "http://localhost:3838/sample-apps/Projet_Rita/R/choix_zone_esp/")
              #   # 
              #   )
              # 
              # ,
              # 
              # fluidRow()
              
              # sidebarPanel(
              # conditionalPanel
              # (
                # condition = "input.suivant == false ",
                    box(
                          width = 4, height ="530" , status = "info",
                          checkboxGroupInput(inputId="zone",label = "ZONE",choices = zn),
                             
                          checkboxGroupInput(inputId="espece",label = "Espece",choices = esp ),
                             
                             actionButton(inputId="suivant", label="suivant"),
                              actionButton(inputId="initialiser", label="initialiser"),
                             tags$br(),
                             actionLink(inputId="help", "Aide")
                      ),
             # ),
                              


                 conditionalPanel
                  (
                    condition = "input.suivant == false || input.initialiser == true",
                     box(
                       width = 8, height ="530" , status = "info",
                              plotOutput(outputId="carte")
                       )
                ),

              conditionalPanel
              (
                condition = "input.suivant == true  ",
                box(
                  width = 8, status = "info"
                  ,tableOutput(outputId='classement')
                )
              )

# 
#  conditionalPanel
#   (
#     condition = "input.suivant == false || input.initialiser == true",
#      box(
#        width = 8, height ="530" , status = "info",
#               plotOutput(outputId="carte")
#        ),
# 
#     conditionalPanel
#     (
#       condition = "input.suivant == true  ",
#       box(
#         width = 8, status = "info"
#         ,tableOutput(outputId='classement')
#       )
#     )
# )

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




# conditionalPanel(
#   condition = "input.plotType == 'hist'",
#   selectInput(
#     "breaks", "Breaks",
#     c("Sturges",
#       "Scott",
#       "Freedman-Diaconis",
#       "[Custom]" = "custom")),
#   
#   # Only show this panel if Custom is selected
#   conditionalPanel(
#     condition = "input.breaks == 'custom'",
#     sliderInput("breakCount", "Break Count", min=1, max=1000, value=10)
#   )
# )