
server = function(output,input)
{
  observeEvent(input$help, {
    shinyjs::alert("Veuillez sélectionner au moins une zone et une espèce")
  })
  
  
  #action générée quand l'utilisateur va cliquer sur suivant
  observeEvent(input$suivant,
               {
                 # output$erreur=renderText({"Veuillez saisir au moins une zone"})
                 #traitement
                 information_user <- read.table("/srv/shiny-server/sample-apps/Projet_Rita/output/information_user2.csv" , header=TRUE, sep=";", stringsAsFactors = FALSE)  
                 l=length(row.names( information_user  ))
                print(l)
                 zn=input$zone
                 e=input$espece
                   
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
                 
                 
                 
                 print(information_user)
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
                 
                 print(list_espe)
                 print(list_zone)
                 
                 # traitement avec les filtres
                 bdd = ldf
                 f=filtre_all(bdd = bdd,list_esp = list_espe ,list_zone = list_zone)
                 #output$table2 = renderTable( f[[2]] )
                 print( f[[2]] )
                 
                 inform_usr=  write.table(information_user,file="/srv/shiny-server/sample-apps/Projet_Rita/output/information_user2.csv",row.names=FALSE,  sep = ";",dec = "," , na = "0")
                 
                # output$table = renderTable(information_user)
                 
                 
                 #source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/app1/ui.R",local = TRUE)
                 
                 
                 
                 
                 
               }
               
  )
  
  
  
  
  
  observe({
    
    e=input$espece
    z=input$zone
    taille_e=length(e)
    taille_z=length(z)
    str(e)
    str(z)
    
    shinyjs::toggleState(id="suivant",taille_e>0 && taille_z>0)
  })
  
}