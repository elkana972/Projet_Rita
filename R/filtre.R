source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/model.R")

# Get the libraries
packs <- c("dplyr", "ggplot2", "tidyr", "viridis", "scales")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)

#options("max.print"=1000000) augmenter la taille du print dans le terminal

#bdd=model()

array_zone = function()
{  
  
  zone = data.frame(id=c("GT","BT","MG"),libelle=c("GRANDE-TERRE","BASSE-TERRE","MARIE-GALANTE") )
  zone = levels(zone$libelle)
  return(zone)
  
}

array_esp = function()
{  
  esp = data.frame(id=c ("Da","Dcr"),libelle=c("Dioscorea-alata","Dioscorea-rotundata" ))
  esp = levels(esp$libelle)
  return(esp)
  
}




filtre_all=function(bdd,list_esp,list_zone)
{
  
   filtre_bdd=bdd
   f=lapply(filtre_bdd,choose_zone_espece,list_esp = list_esp,list_zn = list_zone) 
   return(f)
  
}

choose_zone_espece=function(bdd,list_esp,list_zn)
{
  filtre = subset(bdd,Sp %in% list_esp & Zone %in% list_zn)
}

#faire des tests dans le terminal avant de passer à la partie graphique
# l_esp= list()
# l_esp[["Da"]]="Da"
# l_zn=list()
# l_zn[["GT"]]="GT"
# m=model()
# v=filtre_all(bdd = m ,list_esp = l_esp,list_zone = l_zn)
# print(v[[2]])
