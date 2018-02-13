source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/filtre.R")

#source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/global.R")


zn=array_zone()


ui = fluidPage(
  #déclaration de useShiny pour utiliser les fonctionnalités de shinyjs
  shinyjs::useShinyjs(),
  sidebarLayout(
    
    sidebarPanel(
      tags$h1("Zone"),
    checkboxGroupInput(inputId="zone",label = "Selectionnez la zone qui vous intéresse",
                       choices = zn ),
    actionButton(inputId="suivant", label="suivant",onclick ="location.href='http://localhost:3838/sample-apps/Projet_Rita/R/app2/';"),
    #actionButton(inputId="suivant", label="suivant"),
  
     textOutput(outputId="message") 
    ),
    
  mainPanel(
    
    tags$h1("image de carte de la guadeloupe fournie par INRA.....")
  )
  
  )

  
)