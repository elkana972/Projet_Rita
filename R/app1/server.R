source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/filtre.R")

zn=array_zone()

information_user <- read.table("/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv" , header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
l=length(row.names( information_user  ))
valider=information_user[l,6]

a=47
print(a)

server=function(input,output,session)
{
  

  

  observeEvent(input$help, {
    shinyjs::alert("Si vous ne selectionnez aucune zone vous ne pourrez pas continuer")
  })
  
  #action générée quand l'utilisateur va cliquer sur suivant
   observeEvent(input$suivant,
                {
                  
                   # output$erreur=renderText({"Veuillez saisir au moins une zone"})
                   #traitement
                   zn=input$zone
                 
                   #question : autre methode pour connaitre la dernière ligne du tableau
              
                  #interup=information_user[l,6]
                  
                  
                  if(valider==1)
                  {
                        
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
                    #shinyjs::reset("zone")
                    
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
                  
                  cat("valider server ",valider,"\n")
                  
                  print(information_user)
                  inform_usr=  write.table(information_user,file="/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv",row.names=FALSE,  sep = ";",dec = "," , na = "0")
                  
                  source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/app1/ui.R",local = TRUE)
                  
                  #save(information_user, file="/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv")
                   #close(inform_usr)
                  # source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/app2/server.R")
                  # print(inform_usr)
                  
                }
                
                )

  #désactive le bouton "suivant" si il n'y  élément séctionné
  observe({
   # checkboxGroupInput(inputId="zone",label = "Selectionnez la zone qui vous intéresse",choices = c("d"))
    
    query = parseQueryString(session$clientData$url_search)
    z=input$zone
    taille_z=length(z)
    lg_query = length(query)
    
    if( lg_query > 0)
    {
      

          if(information_user[l,1]==1)
           {
             bt="BASSE-TERRE"
           }else
           {
             bt=""
           }
      
  
           if(information_user[l,2]==1)
           {
             gt="GRANDE-TERRE"

           }else
           {
             gt=""
           }

           if(information_user[l,3]==1)
           {
             mg="MARIE-GALANTE"
           }else
           {
             mg=""
           }
     list_zone=list(bt=bt,gt=gt,mg=mg)
     output$table2=renderTable(list_zone)
     #updateCheckboxGroupInput(session,inputId = "zone",label = "Selectionnez la zone qui vous intéresse",choices = zn,selected = list_zone )
     # updateCheckboxGroupInput(session,inputId = "zone",label = "Selectionnez la zone qui vous intéresse",choices = zn)
      
      #head(fq,2600)
      information_user <- read.table("/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv" , header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
      
      output$table=renderTable(information_user)
      output$message=renderText({l})
      
    }
    else
    {
     # information_user <- read.table("/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv" , header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
      
      output$table=renderTable(information_user)
      output$table2=renderTable(zn)
      output$message=renderText({l})
      
    }
    
    shinyjs::toggleState(id="suivant",taille_z>0)
    
    
    
  })
  
  # onStop(function(){
  #   cat("Session stopped\n")
  #   var=1
  #   cat(var)
  #   })
  
  
  }
