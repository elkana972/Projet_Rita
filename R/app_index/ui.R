source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/filtre.R")
library(shinydashboard)
library(shinyjs)
jscode <- "shinyjs.refresh = function() { location.reload(); }"

zn=array_zone()
esp=array_esp()
note = array_note()
notation = notation_qualita()
n=notation$libelle
l = list()


dashboardPage(
  
  dashboardHeader(
    # Use image in title
    title = "RITA GUADELOUPE Réseau d'innovation et de transfert agricole", titleWidth = 700
  ),
  dashboardSidebar(

   
    sidebarMenu(
      
      menuItem("Accueil", tabName = "accueil",icon = icon("home")),
      menuItem("Outil décisionnel", tabName = "outil",icon = icon("th")),
      menuItem("Fiches variétales", tabName = "fiche", icon = icon("th")),
      menuItem("Météo", tabName = "Météo",   icon = icon("th")),
      menuItem("Partenaires", tabName = "partenaires", icon = icon("th")),
      menuItem("Bailleurs de fonds", tabName = "bailleurs", icon = icon("th")),
      menuItem("Aide", tabName = "aide",icon = icon("life-ring")),
      menuItem("Contact", tabName = "contact",icon = icon("question"))
    )
  ),
  #outil décisionnel
  dashboardBody( 
    shinyjs::useShinyjs(),
    extendShinyjs(text = jscode, functions = "refresh"),
    tags$style(type="text/css", "img { max-width:100%; height: auto; }"),
    tabItems(
      # First tab content
      tabItem(tabName = "accueil",
              fluidRow(
                
                box(
                  actionButton(inputId="refresh", label="Retour à la page d'accueil",onclick ="location.href='http://localhost:3838/sample-apps/Projet_Rita/R/app_index/';"),
                    status = "info",style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                
                box(width = 12 , status = "info",
                       tags$iframe(width = "100%", height = "100%",src = "http://localhost:3838/sample-apps/Projet_Rita/R/accueil/"),
                    style = "width:100%; height:700px; overflow-y: scroll;overflow-x: scroll;")
                
                       )
      ),
      tabItem(tabName = "outil",
              
              fluidRow(
                    box(
                          width = 5 , status = "info",
                          tags$h3("Choix de la zone"),
                          leaflet::leafletOutput(outputId="carte", width = "100%", height = "500"),
                          
                
                          checkboxGroupInput(inputId="zone",label = "",choices = zn, selected = l),
                          p(),
                          actionButton("init", "réinitialiser"),
                          tags$h3("Choix de l'espèce"),
                          actionButton(inputId ="especes", label = "Visualisation des espèces"),
                          checkboxGroupInput(inputId="espece",label = "",choices = esp),
                          
                          # tags$h3("Visualisation des espèces"),
                          # actionButton(inputId ="alata", label = "Dioscorea-alata"),
                          # tags$br(),
                          # tags$br(),
                          # actionButton(inputId ="rotundata", label = "Dioscorea-rotundata"),
                          tags$h3("Affectez une importance aux indicateurs"),
                          selectInput(inputId="note_rendement",label="Production",choices = n),
                          selectInput(inputId="note_resistance",label="Résistance aux maladies",choices = n),
                          selectInput(inputId="note_conservation",label="Conservation en stockage",choices = n),
                          selectInput(inputId="note_qualite",label="Qualité du tubercule",choices = n),
                          selectInput(inputId="note_adventice",label="Tolérance aux adventices",choices = n),
                          actionButton(inputId="suivant", label="suivant"),
                         # actionButton(inputId="initialiser", label="initialiser"),
                             tags$br(),
                             actionLink(inputId="help", "Aide")
                          
                      ),
            
                    box(
                      width = 3 , status = "info" ,
                      tableOutput(outputId='classement')
                      
                      
                    )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "fiche",
              h2("Téléchargement des fiches variétales"),
              box(
                width = 7 , status = "info",
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
           
              fluidRow(
              box(
                width = 12 , status = "info",
              tags$iframe( width = "100%", height = "100%",src = "http://localhost:3838/sample-apps/Projet_Rita/R/meteo/" )
                       ,style = " width:100%; height:700px; overflow-y: scroll;overflow-x: scroll;"
              )
              )
      ),

      
      tabItem(tabName = "aide",
              h2("aide")
      ),
      tabItem(tabName = "contact",
              
              fluidRow(
                box(width = 12,status = "info",
                    tags$table
                    ( 
                      class = "table",
                      tags$thead(
                        tags$tr()), 
                        
                      tags$tr(
                          tags$td(
                              tags$b("Applications et outil d’aide au choix des variétés :"),
                              tags$ul(
                                
                              tags$li("CORNET Denis (Cirad) Denis.cornet@cirad.fr"),
                              tags$li("PUBLICOL Mirza (INRA) Mirza.publicol@inra.fr"),
                              tags$li("LESMOND Elkana (Développeur Web et logiciels) elkana972@hotmail.fr")
                          ))),
                      tags$tr(
                        tags$td(
                          tags$b("Projet Prodimad :",tags$br(), "Chef de projet :"),
                          
                          tags$ul( tags$li("CHAMPOISEAU Patrice (IT2) p.champoiseau@it2.fr"))
                        )),
                      tags$tr(
                        tags$td(
                         
                          tags$b("Partenaires scientifiques et techniques :"),
                          tags$ul(
                          tags$li("ARNAU Gemma (CIRAD) Gemma.arnau@cirad.fr "),
                          tags$li("BURGER Fabien (SICAPAG) f.burger@sicapag.fr"),
                          tags$li("CORNET Denis (Cirad) denis.cornet@cirad.fr"),
                          tags$li("KELLEMEN Jean-Louis (EPLEFPA) jean-louis.kelemen@educagri.fr"),
                          tags$li("LAURENT Lévy (IT2) l.laurent@it2.fr"),
                          tags$li("MALEDON Erick (Cirad) erick.maledon@Cirad.fr"),
                          tags$li("OSSEUX Julian (Chambre d’agriculture) osseux.j@guadeloupe.chambagri.fr"),
                          tags$li("PAVIS Claudie (INRA-CRB) claudie.pavis@antilles.inra.fr"),
                          tags$li("TOURNEBIZE Régis (INRA-Astro) Regis.tournebize@antilles.inra.fr"),
                          tags$li("UMBER Marie (INRA-CRB) marie.umber@antilles.inra.fr")
                          )
                        ))
                        
                    )
              )
      )),

tabItem(tabName = "bailleurs",
        h2("Bailleurs de fonds"),
        fluidRow(
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
        ) ),

tabItem(tabName = "partenaires",
        fluidRow(
        h2("Partenaires"),
        box(
          width = 12, status = "info",
          tags$table
          ( 
            class = "table",
            tags$thead(
              tags$tr(
                tags$th("Partenaires")
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
                )),
              tags$tr(
                tags$td(
                  tags$a( href='http://www.it2.fr/',tags$img(src="logo_IT2.png"))  
                ))
              
              
            )
          )))
)


      
    )
  
  ),
  skin = "green"
)