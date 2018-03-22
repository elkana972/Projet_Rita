# Loading libraries
packs <- c("plotKML", "maptools", "ggmap", "ggthemes", "ggsn", "stringr",
           "raster", "tidyverse", "broom","shinydashboard")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)



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
  
  
  # utilisation de la carte
  
  # Get gwad county boudaries
  gwad<-getData('GADM', country='GLP', level=2) # Adding administrative border
  
  # Get data of tuber production by county ()
  dftub<-read.csv("/opt/shiny-server/samples/sample-apps/Projet_Rita/data/Agreste2010_Gwad_Commune.csv", sep=";", dec=",",header=T,fileEncoding = "latin1")
  
  # Get centroid for each county label
  cnames<-as.data.frame(coordinates(gwad))
  colnames(cnames)<-c("lon", "lat")
  cnames$Commune<-unique(gwad$NAME_2)
  
  # Merge centroid with tuber production by county data (AGRESTE 2010)
  # Check Commune name matching
  com<-which(levels(as.factor(cnames$Commune))!=levels(dftub$Commune))
  levels(dftub$Commune)[com]
  levels(as.factor(cnames$Commune))[com]
  dftub$Commune<-str_to_title(as.character(dftub$Commune))
  cnames$Commune<-str_to_title(cnames$Commune)
  levels(as.factor(cnames$Commune))==levels(as.factor(dftub$Commune))
  dftubc<-left_join(cnames, dftub, by="Commune")
  
  # Extract df from SpatialPolygonsDataframe
  gwad.fort<-tidy(gwad, region="NAME_2")
  
  # Merge both df
  gwad.fort$id<-str_to_title(gwad.fort$id)
  gwad.fort<-left_join(gwad.fort, dftubc, by=c("id"="Commune"))
  gwad.fort$SurfTub.2010<-as.numeric(as.character(gwad.fort$SurfTub.2010))
  gwad.fort$SurfTub.2000<-as.numeric(as.character(gwad.fort$SurfTub.2000))
  
  # Save dataframe
  saveRDS(gwad.fort, "/opt/shiny-server/samples/sample-apps/Projet_Rita/data/GwadBound_TubData.rds" )
  
  # Plot map (chorochromatique)
  ggplot(data=gwad.fort, aes(long, lat.x, group=group, fill=Sample)) + 
    geom_polygon(colour='black') +
    theme_map()+
    geom_text(aes(lon, lat.y, label=id), size=2) +
    coord_map()+
    theme(legend.position="bottom")
  
  # Plot map (choroplethe)
  g=ggplot(data=gwad.fort, aes(long, lat.x, group=group, fill=SurfTub.2010)) + 
    geom_polygon(colour='black') +
    theme_map()+
    coord_map()+
    theme(legend.position=c(.9,.1))+
    scale_fill_continuous("Tuber crops\narea (ha)", low="yellow", high="brown",
                          na.value=NA)+
    ggtitle("Root and tuber crops area by county in Guadeloupe (Agreste 2010)")+
    ggsn::scalebar(dist=20, y.max=16.54391, x.min=-61.916175, 
                   y.min=15.790233, x.max=-60.848110, dd2km=T, model=("WGS84"),
                   anchor=c(x=-60.9, y=16.5), st.size=3)
  
  output$carte = renderPlot({
    
    
    plot(g)
    
  })
  
  
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