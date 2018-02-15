source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/filtre.R")
#source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/app1/server.R")

information_user <- read.table("/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv" , header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
l=length(row.names( information_user  ))

valider= information_user[l,6]
cat("valider ",valider)
zn=array_zone()


ui = fluidPage(
  #déclaration de useShiny pour utiliser les fonctionnalités de shinyjs
  shinyjs::useShinyjs(),
  sidebarLayout(
    
    sidebarPanel(
      tags$h1("Zone"),
      if(valider==0)
      {
          list_zone=list()
          if(information_user[l,1]==1)
          {
            list_zone[["BT"]]="BASSE-TERRE"
          }
          
          if(information_user[l,2]==1)
          {
            list_zone[["GT"]]="GRANDE-TERRE"
          }
          
          if(information_user[l,3]==1)
          {
            list_zone[["MG"]]="MARIE-GALANTE"
          }
          print(list_zone)
          checkboxGroupInput(inputId="zone",label = "Selectionnez la zone qui vous intéresse",choices = zn,selected = list_zone )
      }
      else if(valider==1)
        {
          checkboxGroupInput(inputId="zone",label = "Selectionnez la zone qui vous intéresse",choices = zn)
          
        },
    actionButton(inputId="suivant", label="suivant",onclick ="location.href='http://localhost:3838/sample-apps/Projet_Rita/R/app2/';"),
    actionLink(inputId="help", "Aide"),
    #actionButton(inputId="suivant", label="suivant"),
  
     textOutput(outputId="message") 
    ),
    
  mainPanel(
    
    tags$h1("image de carte de la guadeloupe fournie par INRA.....")
  )
  
  )

  
)