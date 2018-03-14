source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/model.R")
source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/Production.R")
source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/Resistance.R")
source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/Conservation.R")




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
   rdt1<-f[["drdt1"]]
   rdt2<-f[["drdt2"]]
   pla<-f[["dpla"]]
   em<-f[["deme"]]
   san<-f[["dsan"]]
   print(san)
   #rec<-f[["drec"]]
   
   production = production(rdt1,rdt2,pla,em)
   prod = production[[1]]
   conservation = conservation(production[[2]])
   res=resistance(san = san)
   source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/adventice.R")
   adv = resEm
   
   # # #indicateurs 
   # # # production
   prod$I1.1
   prod$I1.2
   prod$I1.3
   prod$I1.4

   res$I2.1
   res$I2.2
   
   conservation$I3.1
   
   # #adv$I5.1
 
   
   print(length(rownames(prod)))
   print(length(rownames(res)))
   print(length(rownames(conservation)))
   print(length(rownames(resEm)))
   
   combi = subset(comb,Sp %in% list_esp & Zone %in% list_zone)
   print(length(rownames(combi)))
   
  # print(length(rownames(adv)))
  
   
   
   return(f)
  
}



filtre_all1=function(bdd,list_esp,list_zone)
{
  
  
  filtre_bdd=bdd
  f=lapply(filtre_bdd,choose_zone_espece,list_esp = list_esp,list_zn = list_zone) 
  rdt1<-f[["drdt1"]]
  rdt2<-f[["drdt2"]]
  pla<-f[["dpla"]]
  em<-f[["deme"]]
  san<-f[["dsan"]]
  #print(san)
  #rec<-f[["drec"]]
  
  production = production(rdt1,rdt2,pla,em)
  prod = production[[1]]
  conservation = conservation(production[[2]])
  res=resistance(san = san)
  source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/adventice.R")
  adv = resEm
  
  # # #indicateurs 
  # # # production
  prod$I1.1
  prod$I1.2
  prod$I1.3
  prod$I1.4
  
  res$I2.1
  res$I2.2
  
  conservation$I3.1
  
  # #adv$I5.1
  
  
  print(length(rownames(prod)))
  print(length(rownames(res)))
  print(length(rownames(conservation)))
  print(length(rownames(resEm)))
  
  combi = subset(comb,Sp %in% list_esp & Zone %in% list_zone)
  print(length(rownames(combi)))
  list_ind=list(prod = prod , res = res , cons = conservation , adv = adv)
  # print(length(rownames(adv)))
  
  
  
  return(list_ind)
  
}


choose_zone_espece=function(bdd,list_esp,list_zn)
{
  filtre = subset(bdd,Sp.x %in% list_esp & Zone %in% list_zn)
}

#faire des tests dans le terminal avant de passer à la partie graphique
#l_esp= list("Da","Dcr")
l_esp= list("Da")

# l_esp[["Da"]]="Da"
# l_esp[["Dcr"]]="Dcr"

l_zn=list("BT","GT")
#l_zn=list("MG")
# l_zn[["GT"]]="GT"
# l_zn[["BT"]]="BT"
# l_zn[["BT"]]="MG"
m=ldf
v=filtre_all1(bdd = m ,list_esp = l_esp,list_zone = l_zn)
prod =v[["prod"]]
res =v[["res"]]
cons =v[["cons"]]
adv =v[["adv"]]

# normalisation 


# print(v[[2]])

# problèmes rencontrés avec les filtres
#  (Dcr / GT) || (Da / GT) || (Da-Dcr / MG) : resistance 