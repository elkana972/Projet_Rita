

server = function(input,output,session)
  {
  
  information_user <- read.table("/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv" , header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
  l=length(row.names( information_user  ))
  
  #action générée quand l'utilisateur va cliquer sur suivant
  observeEvent(input$valider,
               {
                 
                 # output$erreur=renderText({"Veuillez saisir au moins une zone"})
                 #traitement
                 e=input$espece
                 #question : autre methode pour connaitre la dernière ligne du tableau
                 
                 #intialisation 
                 information_user[l,4]=0
                 information_user[l,5]=0
                 
                 for(i in 1: length(e))
                 {
                   if(e[i]=="Dioscorea-alata")
                   {
                     information_user[l,4]=1
                   }
                   else if(e[i]=="Dioscorea-rotundata")
                   {
                     information_user[l,5]=1
                   }
                   
                 }
                 print(information_user)
                 # mise en place du vecteur zone et espece pour utiliser dans la fonction filtre
                 list_espe=list()
                 list_zone=list()
                 # Basse-TERRE
                 if(information_user[l,1]==1)
                 {
                   list_zone[["BT"]]="BT"
                 }
                 
                 if(information_user[l,2]==1)
                 {
                   list_zone[["GT"]]="GT"
                 }
                 
                 if(information_user[l,3]==1)
                 {
                   list_zone[["MG"]]="MG"
                 }
                 
                 if(information_user[l,4]==1)
                 {
                   list_espe[["Da"]]="Da"
                 }
                 
                 if(information_user[l,5]==1)
                 {
                   list_espe[["Dcr"]]="Dcr"
                 }
                 
                 print(list_espe)
                 print(list_zone)
                 
                 # traitement avec les filtres
                 bdd = model()
                 f=filtre_all(bdd = bdd,list_esp = list_espe ,list_zone = list_zone)
                 output$table2 = renderTable( f[[2]] )
                 print( f[[2]] )
                 information_user[l,6]=1
                 
                 output$table = renderTable(information_user)
                 
                 inform_usr=  write.table(information_user,file="/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv",row.names=FALSE,  sep = ";",dec = "," ,na = "0")
                 #close(file="/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv")
                 
                 #Sys.sleep(6)
               }
               
  )
  
  observeEvent(input$precedent,
               {
                 source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/app1/server.R",local = TRUE)
                # source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/app1/ui.R",local = TRUE)
                 
               }
  )
  
  
  #désactive le bouton "valider" si il n'y pas d'éléments séctionnés
  observe({
    output$table = renderTable(information_user)
    e=input$espece
    taille_e=length(e)
    str(e)
    
    shinyjs::toggleState(id="valider",taille_e>0)
  })
  
  # onStop(function(){
  #   cat("Session stopped\n")
  #   information_user[l,1]=0
  #   information_user[l,2]=0
  #   information_user[l,3]=0
  #   inform_usr=  write.table(information_user,file="/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv",row.names=FALSE,  sep = ";",dec = "," ,na = "0")
  # 
  #   })

  }
    
  

