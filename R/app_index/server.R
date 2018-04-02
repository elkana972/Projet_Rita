# Loading libraries
packs <- c("plotKML", "maptools", "ggmap", "ggthemes", "ggsn", "stringr",
           "raster", "tidyverse", "broom","shinydashboard","leaflet","raster")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)



server <- function(input, output) { 
  
  
  observeEvent(input$help, {
    shinyjs::alert(tags$img(src="RITA_Gwada.jpg"))
    #shinyjs::alert( tags$h4("Veuillez sélectionner au moins une zone et une espèce") )
    
    
  })
  

  
  gwad0<-getData('GADM', country='GLP', level=1) # Adding administrative border
  gwad0@data$ID_0<-c("Basse-Terre", "Grande-Terre et Marie-Galante")
  gwad0 <- spChFIDs(gwad0, as.character(gwad0$ID_0))
  row.names(as(gwad0, "data.frame"))

  output$carte = renderLeaflet({
      leaflet(gwad0) %>%
        addPolygons(color="#444444", weight=1, smoothFactor=.5,
                    opacity=1, fillOpacity=.5, label=~as.character(ID_0),
                    fillColor=~colorQuantile("YlOrRd", OBJECTID)(OBJECTID),
                    highlightOptions=highlightOptions(color="green", weight=3,
                                                      bringToFront=T),
                    labelOptions=labelOptions(clickable=T, offset=c(10,-18)))
  })
  
  
  ############################################################
  
  ############################################################
 # observeEvent( input$, {foo})
  observe({
    
    e=input$espece
    z=input$zone
    taille_e=length(e)
    taille_z=length(z)
    #str(e)
    #str(z)
  
    shinyjs::toggleState(id="suivant",taille_e>0 && taille_z>0)
  })
  ############################################################
  
  
  
  ############################################################
  #action générée quand l'utilisateur va cliquer sur suivant
  observeEvent(input$suivant,
               {
                 information_user <- read.table("/srv/shiny-server/sample-apps/Projet_Rita/output/information_user2.csv" , header=TRUE, sep=";", stringsAsFactors = FALSE)  
                 # output$erreur=renderText({"Veuillez saisir au moins une zone"})
                 #traitement
                 l=length(row.names( information_user  ))
                 #print(l)
                 source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/filtre.R")
                 
                 notation = notation_qualita()
                
                 zn=input$zone
                 e=input$espece
                 
                 rdt = input$note_rendement
                 rdt = which(notation$libelle==rdt)
                 rdt = notation$note[rdt]
      
                 res = input$note_resistance
                 res = which(notation$libelle==res)
                 res = notation$note[res]
                 
                 
                 cons = input$note_conservation
                 cons = which(notation$libelle==cons)
                 cons = notation$note[cons]
                 
                 
                 qual = input$note_qualite
                 qual = which(notation$libelle==qual)
                 qual = notation$note[qual]
                 
                 
                 
                 adv = input$note_adventice
                 adv = which(notation$libelle==adv)
                 adv = notation$note[adv]
                 
                 
                 
                 cat("rdt ",rdt," adv ",adv)
                 poids_indicateur = c(rdt,res,cons,qual,adv)
                 information_user[l+1,1]=0
                 information_user[l+1,2]=0
                 information_user[l+1,3]=0
                 information_user[l+1,4]=0
                 information_user[l+1,5]=0
                 information_user[l+1,6]=0
                 
                 information_user[l+1,1]= format(Sys.time(), "%m/%d/%Y %H:%M:%S")
                 for(i in 1: length(zn))
                 {
                   if(zn[i]=="BASSE-TERRE")
                   {
                     information_user[l+1,2]=1
                   }
                   else if(zn[i]=="GRANDE-TERRE")
                   {
                     information_user[l+1,3]=1
                   }
                   else if(zn[i]=="MARIE-GALANTE")
                   {
                     information_user[l+1,4]=1
                     
                   }
                 }
                 
                 for(i in 1: length(e))
                 {
                   if(e[i]=="Dioscorea-alata")
                   {
                     information_user[l+1,5]=1
                   }
                   else if(e[i]=="Dioscorea-rotundata")
                   {
                     information_user[l+1,6]=1
                   }
                   
                 }                   
                 
                 # print(information_user)
                 # mise en place du vecteur zone et espece pour utiliser dans la fonction filtre
                 list_espe=list()
                 list_zone=list()
                 # Basse-TERRE
                 if(information_user[l+1,2]==1)
                 {
                   list_zone[["BT"]]="BT"
                 }
                 
                 if(information_user[l+1,3]==1)
                 {
                   list_zone[["GT"]]="GT"
                 }
                 
                 if(information_user[l+1,4]==1)
                 {
                   list_zone[["MG"]]="MG"
                 }
                 
                 if(information_user[l+1,5]==1)
                 {
                   list_espe[["Da"]]="Da"
                 }
                 
                 if(information_user[l+1,6]==1)
                 {
                   list_espe[["Dcr"]]="Dcr"
                 }
                 
                 #print(list_espe)
                 #print(list_zone)
                 
                 # traitement avec les filtres
                 bdd = ldf
                 f=filtre_all1(bdd = bdd,list_esp = list_espe ,list_zone = list_zone)
                 #output$table2 = renderTable( f[[2]] )
                 #print( f[[7]] )
                 #print(poids_indicateur
                 
                 
                 cat(" test ",rdt,res,cons,qual,adv)
                 
               n = normalisation(f , list_esp = list_espe ,list_zone = list_zone,rdt,res,cons,qual,adv )
              inform_usr=  write.table(information_user,file="/srv/shiny-server/sample-apps/Projet_Rita/output/information_user2.csv",row.names=FALSE,  sep = ";",dec = "," , na = "0")
                 #output$table=renderTable(information_user)
                 
              output$classement = renderTable(n)
                 # output$table = renderTable(information_user)
                 
                 #source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/app1/ui.R",local = TRUE)
                 
               }
               
  )
  ############################################################
  
  
  
  observeEvent(input$alata, {
    showModal(modalDialog(
      title = tags$a(href='',tags$img(src="alata1.png")),
      
      easyClose = TRUE,
      footer = modalButton("Fermer")
    ))})
  
  observeEvent(input$rotundata, {
    showModal(modalDialog(
      title = tags$a(href='',tags$img(src="rotundata.png")),
      
      easyClose = TRUE,
      footer = modalButton("Fermer")
    ))})
  
  
  
  
  
  
  
  }