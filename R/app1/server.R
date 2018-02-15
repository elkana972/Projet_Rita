
server=function(input,output,session)
{
  
  information_user <- read.table("/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv" , header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
  l=length(row.names( information_user  ))
  print(l)
  

  #action générée quand l'utilisateur va cliquer sur suivant
   observeEvent(input$suivant,
                {
                   # output$erreur=renderText({"Veuillez saisir au moins une zone"})
                   #traitement
                   zn=input$zone
                 
                   #question : autre methode pour connaitre la dernière ligne du tableau
              
                  #interup=information_user[l,6]
                  valider=information_user[l,6]
                  
                  if(valider==1)
                  {
                        cat("debut")
                        for(i in 1: length(zn))
                        {
                          if(zn[i]=="BASSE-TERRE")
                          {
                            information_user[l+1,1]=1
                          }
                          else if(zn[i]=="GRANDE-TERRE")
                          {
                            information_user[l+1,2]=1
                          }
                          else if(zn[i]=="MARIE-GALANTE")
                          {
                            information_user[l+1,3]=1
                            
                          }
                          
                        }
                    output$message=renderText({"nouvelle ligne"})
                  }
                  else if(valider==0)
                  {
                    cat("en cours")
                    #initialisation
                    information_user[l,1]=0
                    information_user[l,2]=0
                    information_user[l,3]=0
                    
                    for(i in 1: length(zn))
                    {
                      if(zn[i]=="BASSE-TERRE")
                      {
                        information_user[l,1]=1
                      }
                      else if(zn[i]=="GRANDE-TERRE")
                      {
                        information_user[l,2]=1
                      }
                      else if(zn[i]=="MARIE-GALANTE")
                      {
                        information_user[l,3]=1
                        
                      }
                     
                      
                    } 
                    output$message=renderText({"ligne en cours"})
                  }
                  
                  inform_usr=  write.table(information_user,file="/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv",row.names=FALSE,  sep = ";",dec = "," , na = "0")
                 close(inform_usr)
                  # source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/app2/server.R")
                  
                }
                
                )

  #désactive le bouton "suivant" si il n'y  élément séctionné
  observe({
    
    #query = parseQueryString(session$clientData$url_search)
    z=input$zone
    taille_z=length(z)
    #lg_query = length(query)
    
    
    
    shinyjs::toggleState(id="suivant",taille_z>0)
    
    
  })
  
  # onStop(function(){
  #   cat("Session stopped\n")
  #   var=1
  #   cat(var)
  #   })

  }
