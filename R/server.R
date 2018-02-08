

server=function(input,output)
{
  
  #action générée quand l'utilisateur va cliquer sur suivant
   observeEvent(input$suivant,
                {
                  
                    output$erreur=renderText({"Veuillez saisir au moins une zone"})
                 
                }
                )

  #désactive le bouton suivant si il n'y a aucun élément séctionné
  observe({
    z=input$zone
    taille_z=length(z)
    shinyjs::toggleState(id="suivant",taille_z>0)
  })
  
}