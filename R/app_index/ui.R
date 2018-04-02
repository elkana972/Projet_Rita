source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/filtre.R")

library(shinydashboard)

zn=array_zone()
esp=array_esp()
note = array_note()
notation = notation_qualita()
n=notation$libelle

dashboardPage(
  dashboardHeader(
    # 
  
    # Use image in title
    # title = tags$a(href='http://localhost:3838/sample-apps/Projet_Rita/R/app_index/',tags$img(src="RITA_Gwada.jpg"))
    title = "RITA GUADELOUPE Réseau d'innovation et de transfert agricole", titleWidth = 450
  ),
  dashboardSidebar(

   
    sidebarMenu(
      menuItem("Accueil", tabName = "accueil",icon = icon("home")),
      menuItem("Fiches variétales", tabName = "fiche", icon = icon("th")),
      menuItem("Météo", tabName = "Météo",   icon = icon("th")),
      
    
      menuItem("Partenaires", tabName = "partenaires", icon = icon("th")),
      menuItem("Bailleurs de fonds", tabName = "bailleurs", icon = icon("th")),
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
              
              # ,
              # 
              # fluidRow()
              
              # sidebarPanel(
              # conditionalPanel
              # (
                # condition = "input.suivant == false ",
                    box(
                          width = 5 , status = "info",
                          checkboxGroupInput(inputId="zone",label = "ZONE",choices = zn),
                        
                          checkboxGroupInput(inputId="espece",label = "Espèce",choices = esp ),
                          tags$h3("Visualisation des espèces"),
                          actionButton(inputId ="alata", label = "Dioscorea-alata"),
                          actionButton(inputId ="rotundata", label = "Dioscorea-rotundata"),
                          tags$h3("Affectez une importance aux indicateurs"),
                          selectInput(inputId="note_rendement",label="Production",choices = n),
                          selectInput(inputId="note_resistance",label="Résistance aux maladies",choices = n),
                          selectInput(inputId="note_conservation",label="Conservation en stockage",choices = n),
                          selectInput(inputId="note_qualite",label="Qualité du tubercule",choices = n),
                          selectInput(inputId="note_adventice",label="Tolérance aux adventices",choices = n),
                        
                             
                             actionButton(inputId="suivant", label="suivant"),
                              actionButton(inputId="initialiser", label="initialiser"),
                             tags$br(),
                             actionLink(inputId="help", "Aide")
                          
                      ),
            
                              


                # conditionalPanel
                #  (
                #    condition = "input.suivant == false || input.initialiser == true",
                     box(
                       width = 4 , status = "info",
                       leaflet::leafletOutput(outputId="carte", width = "100%", height = "500")
                       ),
                # ),

                    box(
                      width = 3 , status = "info" ,
                      tableOutput(outputId='classement')
                      
                      
                    )
      
              # conditionalPanel
              # (
              #   condition = "input.suivant == true  ",
              #   box(
              #     width = 8, status = "info"
              #     ,tableOutput(outputId='classement')
              #   )
              # )

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
              h2("Téléchargement des fiches variétales"),
              box(
                width = 7 , status = "info",
                # tags$div(
                # paste("Alano"),
                # downloadButton(outputId="alano", label = "ALANO")),
                # 
                # tags$div(
                # paste("Belo"),
                # downloadButton(outputId="belo", label = "BELO"))
                tags$table
                ( 
                  class = "table",
                  tags$thead(
                  tags$tr(
                    tags$th("Variété"),
                    tags$th("Téléchargement")
                  ),
                  tags$tr(
                    tags$td("ALANO"),
                    tags$td(
                      tags$a( href='http://localhost:3838/sample-apps/Projet_Rita/data/fiche_varietale/Alano.pdf',"ALANO")  
                  )),
                  tags$tr(
                    tags$td("BELO"),
                    tags$td(
                    tags$a( href='http://localhost:3838/sample-apps/Projet_Rita/data/fiche_varietale/Belo.pdf',"BELO")  
                    
                  )),
                  tags$tr(
                    tags$td("COCO"),
                    tags$td(
                    tags$a( href='http://localhost:3838/sample-apps/Projet_Rita/data/fiche_varietale/Coco.pdf',"COCO")  
                    
                  )),
                  tags$tr(
                    tags$td("INRA15"),
                    tags$td(
                    tags$a( href='http://localhost:3838/sample-apps/Projet_Rita/data/fiche_varietale/INRA15.pdf',"INRA15")  
                    
                  )),
                  tags$tr(
                    tags$td("JANO"),
                    tags$td(
                    tags$a( href='http://localhost:3838/sample-apps/Projet_Rita/data/fiche_varietale/Jano.pdf',"JANO")  
                    
                  )),
                  tags$tr(
                    tags$td("MALAGI"),
                    tags$td(
                    tags$a( href='http://localhost:3838/sample-apps/Projet_Rita/data/fiche_varietale/Malalagi.pdf',"MALALAGI")  
                    
                  )),
                  tags$tr(
                    tags$td("ORGAL"),
                    tags$td(
                    tags$a( href='http://localhost:3838/sample-apps/Projet_Rita/data/fiche_varietale/Orgal.pdf',"ORGAL")  
                    
                  )),
                  tags$tr(
                    tags$td("TICLAIR"),
                    tags$td(
                    tags$a( href='http://localhost:3838/sample-apps/Projet_Rita/data/fiche_varietale/TiClair.pdf',"TICLAIR")  
                    
                  ))
                
                  )
                  
                )
                
                
              )
      ),

      tabItem(tabName = "Météo",
              column(12,tags$iframe( width = "900", height = "500",src = "http://localhost:3838/sample-apps/Projet_Rita/R/meteo/" ))
      ),

      
      tabItem(tabName = "aide",
              h2("aide")
      ),
      tabItem(tabName = "contact",
              h2("contact")
      ),

tabItem(tabName = "bailleurs",
        h2("Bailleurs de fonds"),
        box(
          width = 9 , status = "info",
          tags$table
          ( 
            class = "table",
            tags$thead(
              tags$tr(
                tags$th("Bailleurs")
              ),
              tags$tr(
              tags$td(
                tags$a( href='https://www.europe-guadeloupe.fr/feader',tags$img(src="logo_Europe.jpg"))  
              )),
              tags$tr(
                tags$td(
                  tags$a( href='http://www.odeadom.fr/',tags$img(src="logo_ODEADOM.jpg"))  
                )),
              tags$tr(
                tags$td(
                  tags$a( href='http://www.regionguadeloupe.fr/accueil/#_',tags$img(src="logo_RegionGuadeloupe.png"))  
                ))
              
            )
          )
          
          )
        ),

tabItem(tabName = "partenaires",
        h2("Partenaires"),
        box(
          width = 12, status = "info",
          tags$table
          ( 
            class = "table",
            tags$thead(
              tags$tr(
                tags$th("partenaires")
              ),
              tags$tr(
                tags$td(
                  tags$a( href='https://www.cirad.fr/',tags$img(src="logo_cirad.png"))  
                )),
              tags$tr(
                tags$td(
                  tags$a( href='http://institut.inra.fr/',tags$img(src="logo_INRA.jpg"))  
                )),
              tags$tr(
                tags$td(
                  tags$a( href='http://www.chambres-agriculture.fr/chambres-dagriculture/nous-connaitre/lannuaire-des-chambres-dagriculture/fiche-annuaire-dune-chambre-dagriculture/fiche/chambre-dagriculture-de-la-guadeloupe/',tags$img(src="logo_CA_Guadeloupe.JPG"))  
                )),
              
              tags$tr(
                tags$td(
                  tags$a( href='http://www.sicapag-gpe.fr/',tags$img(src="logo_sicapag.png"))  
                )),
              tags$tr(
                tags$td(
                  tags$a( href='http://www.guadeloupe.educagri.fr/',tags$img(src="logo_EPLEFPA.gif"))  
                ))
              
              
            )
          )
          
        )
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