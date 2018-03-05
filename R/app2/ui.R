source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/filtre.R")



esp=array_esp()


ui = fluidPage(
  #déclaration de useShiny pour utiliser les fonctionnalités de shinyjs
  shinyjs::useShinyjs(),
  sidebarLayout(
    
    sidebarPanel(
      tags$h1("Espece"),
      checkboxGroupInput(inputId="espece",label = "Selectionnez l'espece qui vous intéresse",
                         choices = esp ),
      #actionButton(inputId="suivant", label="suivant",onclick ="location.href='http://localhost:3838/sample-apps/Projet_Rita/R/app2/';"),
      actionButton(inputId="precedent", label="precedent",onclick ="location.href='http://localhost:3838/sample-apps/Projet_Rita/R/app1/?req=1';"),
      actionButton(inputId="valider", label="valider")
      
      
      ),
    
    mainPanel(
      
      tags$h1("image descriptive des especes.....aaa"),tableOutput(outputId='table'),tableOutput(outputId='table2')
    )
    
  )
  
  
)