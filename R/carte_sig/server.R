# Loading libraries
packs <- c("plotKML", "maptools", "ggmap", "ggthemes", "ggsn", "stringr",
           "raster", "tidyverse", "broom","shinydashboard")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)





server = function(input,output)
{
  
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
  
  output$graphique = renderPlot({
    
    
    plot(g)
    
  })
  
  
}