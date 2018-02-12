
server=function(input,output,session)
{
  
  
  
  
  #action générée quand l'utilisateur va cliquer sur suivant
   observeEvent(input$suivant,
                {
                   # output$erreur=renderText({"Veuillez saisir au moins une zone"})
                   #traitement
                  zn=input$zone
                  information_user <- read.table("/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv" , header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
                  #question : autre methode pour connaitre la dernière ligne du tableau
                  l=length(row.names( information_user  ))
                  
                  query = parseQueryString(session$clientData$url_search)
                  lg_query=length(query)
                  
                  if(lg_query==0)
                  {
                  #output$message=renderText({length(query)})
                  
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
                  }
                  else
                  {
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
                    
                  }
                  
                  inform_usr=  write.table(information_user,file="/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv",row.names=FALSE,  sep = ";",dec = "," , na = "0")
                  source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/app2/server.R")
                  
                }
                
                )

  #désactive le bouton "suivant" si il n'y  élément séctionné
  observe({
    
    z=input$zone
    #print(z)
    taille_z=length(z)
    shinyjs::toggleState(id="suivant",taille_z>0)
  })
  
 
}
