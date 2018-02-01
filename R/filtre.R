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

array_esp = function()
{  
  esp =data.frame( Dioscorea_alata=c("Da"), Dioscorea_rotundata=c("Dcr") )
  return(esp)
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
  
      print(iter_list)
  
  #    Permet d’extraire des observations selon une condition logique, dans notre cas ça dependra de la zone choisie par l'utilisateur
      filtre_bdd[[iter_list]] = dplyr::filter( filtre_bdd[[iter_list]] , filtre_bdd[[iter_list]]$Zone!=zone_recup )
  
      iter_list=iter_list+1
  
    }

  return(filtre_bdd)
  
}


#  f_e=filtre_zone(bdd = bdd,espece = "Dioscorea_rotundata" )

filtre_espece=function(bdd,espece)
{
  filtre_bdd=bdd
  a_e=array_esp()
  print(a_e)
  #recup correspond à recuperation 
  esp_recup=a_e[,espece]
  esp_recup=levels(esp_recup)
  # 
  # #parcourir la liste
  iter_list=1
  for( i in 1:length(filtre_bdd) )
  {
    #    Permet d’extraire des observations selon une condition logique, dans notre cas ça dependra de la zone choisie par l'utilisateur
    filtre_bdd[[iter_list]] = dplyr::filter( filtre_bdd[[iter_list]] , filtre_bdd[[iter_list]]$Sp!=esp_recup )
    iter_list=iter_list+1

  }

  return(filtre_bdd)

  
}