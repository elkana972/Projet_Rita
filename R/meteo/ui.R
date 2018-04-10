# Get the libraries
packs <- c("dplyr", "ggplot2", "tidyr", "viridis", "scales")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)

df<- read.table("~/data_rita/MeteoGwad_10-16_Lesmond.csv", header=TRUE,sep=";", na.strings="NA", dec=",", strip.white=TRUE)
an = as.factor(df$AN)
an = levels(an)

ui = fluidPage(
  
  shinyjs::useShinyjs(),
  sidebarLayout
  (
    
    sidebarPanel(
      selectInput(inputId="choix_graph",choices = c("Température","Pluviométrie","Humidité","Radiation"),label = NULL),
      selectInput(inputId="an",choices = an,label = "Année"),
      actionButton(inputId="valider", label="valider")
      
      ),
    
    
    mainPanel(
     # tags$div(width = 600, style = 'overflow-x: scroll',   plotOutput(outputId="graphique", width = "100%") )
      tags$div(plotOutput(outputId="graphique", width = "100%") )
      
    )
  )
  
)