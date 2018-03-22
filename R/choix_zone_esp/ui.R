
source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/filtre.R")
zn=array_zone()
esp=array_esp()


ui = fluidPage(
  #déclaration de useShiny pour utiliser les fonctionnalités de shinyjs
  shinyjs::useShinyjs(),
  
  fluidRow(
    
    column(3,  
           
      checkboxGroupInput(inputId="zone",label = "ZONE",choices = zn),
    
      checkboxGroupInput(inputId="espece",label = "Espece",choices = esp ),
      
      actionButton(inputId="suivant", label="suivant"),
      tags$br(),
      actionLink(inputId="help", "Aide")
    ),
    column(7,
           plotOutput(outputId="carte")
    )
    
  
  )
  
  
)