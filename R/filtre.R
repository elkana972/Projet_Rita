source("data/model.R")

# Get the libraries
packs <- c("dplyr", "ggplot2", "tidyr", "viridis", "scales")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)

#options("max.print"=1000000) augmenter la taille du print dans le terminal

bdd=model()

array_zone = function()
{  
  zone =data.frame( Grande_Terre=c("GT"), Basse_Terre=c("BT") , Marie_Galante=c("MG") )
  return(zone)
}

#faire des tests dans le terminal avant de passer à la partie graphique
# > f_z=filtre_zone(bdd = bdd,zone = "Marie_Galante" )


filtre_zone=function(bdd,zone)
{
  filtre_bdd=bdd
  a_z=array_zone()
  #recup correspond à recuperation 
  zone_recup=a_z[,zone]
  zone_recup=levels(zone_recup)

  #parcourir la liste
   iter_list=1
   for( i in 1:length(filtre_bdd) )
   {
     
     f = filtre_bdd[[iter_list]]
     
     dplyr::filter(f,f$Zone!=zone_recup)
     
     iter_list=iter_list+1
     
   }
  
  return(bdd)

}

filtre_espece=function()
{
  
}