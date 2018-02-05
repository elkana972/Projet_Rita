source("filtre.R")

zn=array_zone()


ui = fluidPage(
  
  #titlePanel(" Projet Rita"),
  sidebarLayout(
    
    sidebarPanel(
      tags$h1("Zone"),
    checkboxGroupInput(inputId="zone",label = "Selectionnez la zone qui vous intéresse",
                       choices = zn ),
    actionButton(inputId="suivant", label="suivant")
   
    ),
    
  mainPanel(
    
    tags$h1("Image")
  )
  
  )

  
)