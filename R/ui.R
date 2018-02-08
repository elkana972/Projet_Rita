source("filtre.R")

zn=array_zone()
a=1

ui = fluidPage(
  #déclaration de useShiny pour utiliser les fonctionnalités de shinyjs
  shinyjs::useShinyjs(),
  sidebarLayout(
    
    sidebarPanel(
      tags$h1("Zone"),
    checkboxGroupInput(inputId="zone",label = "Selectionnez la zone qui vous intéresse",
                       choices = zn ),
    actionButton(inputId="suivant", label="suivant",onclick ="location.href='http://localhost:3838/sample-apps/Projet_Rita/R/';")
    #actionButton(inputId="suivant", label="suivant"),
  
    #   textOutput(outputId="erreur") 
    ),
    
  mainPanel(
    
    tags$h1("image de carte de la guadeloupe fournie par INRA.....")
  )
  
  )

  
)