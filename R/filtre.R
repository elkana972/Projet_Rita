source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/model.R")
source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/Production.R")
source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/Resistance.R")
source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/Conservation.R")



# Get the libraries
packs <- c("dplyr", "ggplot2", "tidyr", "viridis", "scales","Rcpp")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)

#options("max.print"=1000000) augmenter la taille du print dans le terminal

#bdd=model()

array_note = function()
{
  mat <- matrix(data = 1:5,nrow=5, ncol=1)
  return(mat)
}

notation_qualita = function()
{
  notation = data.frame(note=c(1,2,3,4,5),libelle=c("insuffisant","très moyen","moyen","bien","très bien") )

  return(notation)
}

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

ScalingFct<-function(x) { ifelse(diff(range(x, na.rm=T))==0, .5,
                                 (x-min(x, na.rm=T))/diff(range(x, na.rm=T))) }

filtre_all1=function(bdd,list_esp,list_zone)
{
  filtre_bdd=bdd
  f=lapply(filtre_bdd,choose_zone_espece,list_esp = list_esp,list_zn = list_zone) 
  # rdt1<-f[["drdt1"]]
  # rdt2<-f[["drdt2"]]
  # pla<-f[["dpla"]]
  # em<-f[["deme"]]
  # san<-f[["dsan"]]
  # #print(san)
  # rec<-f[["drec"]]
  
  # production = production(rdt1,rdt2,pla,em)
  # prod = production[[1]]
  # conservation = conservation(production[[2]])
  # res=resistance(san = san)
  # source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/adventice.R",local = TRUE )
  # adv = resEm
  # 
  # # # #indicateurs 
  # # # # production
  # prod$I1.1
  # prod$I1.2
  # prod$I1.3
  # prod$I1.4
  # 
  # res$I2.1
  # res$I2.2
  # 
  # conservation$I3.1
  # 
  # # #adv$I5.1
  # 
  # 
  # print(length(rownames(prod)))
  # print(length(rownames(res)))
  # print(length(rownames(conservation)))
  # # print(length(rownames(resEm)))
  # 
  # combi = subset(comb,Sp %in% list_esp & Zone %in% list_zone)
  # print(length(rownames(combi)))
  # list_ind=list(prod = prod , res = res , cons = conservation , adv = adv)
  # print(length(rownames(adv)))
  # 
  # 
  # 
  # return(list_ind)
  return(f)
}

normalisation = function(bdd,list_esp,list_zone,sco_rdt,sco_res,sco_cons,sco_qual,sco_adv)
{
  
  rdt1<-bdd[["drdt1"]]
  rdt2<-bdd[["drdt2"]]
  pla<-bdd[["dpla"]]
  em<-bdd[["deme"]]
  san<-bdd[["dsan"]]
  
  #print(pla)
  production =production(rdt1,rdt2,pla,em)
  
  #rendement 
  rdt = production[[1]]
  pla = production[[2]]
  
  #conservation
  cons = conservation(pla)
  
  print(cons)
  #resistance 
  sans = resistance(san)
  
  #adventice 
  
  #if(res > 0)
  #{
      rdt = subset(rdt,Sp %in% list_esp & Zone %in% list_zone)
      #
      pla = subset(cons,Sp %in% list_esp & Zone %in% list_zone)
      #
      sans = subset(sans,Sp %in% list_esp & Zone %in% list_zone)

      print(length(rownames(rdt)))

      print(length(rownames(pla)))

      print(length(rownames(sans)))
      
      #print(res)
      # Merge constraints df
      ind<-left_join(rdt, sans, by=c("AN", "Zone", "Parcelle", "Sp", "Var"))
      ind<-left_join(ind, pla, by=c("AN", "Zone", "Parcelle", "Sp", "Var"))
      
     # print(ind)
      
  # }else
  # {
  #   rdt = subset(rdt,Sp %in% list_esp & Zone %in% list_zone)
  #   
  #   pla = subset(cons,Sp %in% list_esp & Zone %in% list_zone)
  # 
  #   
  #   print(length(rownames(rdt)))
  #   
  #   print(length(rownames(pla)))
  #   
  #   #print(res)
  #   # Merge constraints df
  #   ind<-left_join(ind, pla, by=c("AN", "Zone", "Parcelle", "Sp", "Var"))
  # }
  
  # Scaling Subindicators between 0-1 for each situation
  # scaling by situation in order not to favor variety 
  # not evaluated in poor situation (e.g. SF)
  
  ind<-mutate_at(group_by(ind, AN, Zone, Parcelle, Sp), vars(contains("I")),
                 ScalingFct)
  
  
  #Polarization of subindicators
  indg<-gather(ind, SubInd, Value, starts_with("I"))
  NegSubInd<-c("I1.3", "I1.4", "I2.1", "I2.1", "I3.2")
  indg$Value<-ifelse(indg$SubInd %in% NegSubInd, 1-indg$Value, indg$Value)

  # Estimating Indicator scores (mean of subindicators)
  indg<-separate(indg, col=SubInd, into=c("Ind", "SubIn"), sep="\\.")
  indgs<-dplyr::summarize(group_by(indg, AN, Zone, Parcelle, Sp, Var, Ind),
                          IndScores=mean(Value, na.rm=T))

  # Multiply each indicator by its weight (coming from farmers prioritization)
  # !!!!!!!!!!!!!!!!!!!!! Elkan
  
  cat("    ",sco_rdt,sco_res,sco_cons,sco_qual,sco_adv)
  prior<-data.frame(Ind=c("I1", "I2", "I3", "I4", "I5"), Prio=c(as.integer(sco_rdt),as.integer(sco_res),as.integer(sco_cons),as.integer(sco_qual),as.integer(sco_adv)) )
  # !!!!!!!!!!!!!!!!
  indgs<-left_join(indgs, prior, by="Ind")
  indgs$IndScoresPrior<-indgs$IndScores*indgs$Prio

  # Estimatin situation score (sum of weighted indicators for each situation)
  indgs<-dplyr::summarize(group_by(indgs, AN, Zone, Parcelle, Sp, Var),
                          SitScore=sum(IndScoresPrior))

  # Estimatin Varietal score (mean between situations)
  indgs<-dplyr::summarize(group_by(indgs, Sp, Var),
                          VarScore=mean(SitScore, na.rm=T),
                          N=sum(!is.na(SitScore)),
                          SD_VarScore=sd(SitScore, na.rm=T))
  
  # Sort data by score and selecty usefull variables
  dffinal<-dplyr::select(ungroup(indgs), Var,  VarScore)
  colnames(dffinal)<-c("Variété", "Score")

  #print(indgs)
  return(dffinal)
  #print(cons)
  # rdt1<-bdd[["drdt1"]]
  # rdt2<-bdd[["drdt2"]]
  # pla_bd<-bdd[["dpla"]]
  # em_bd<-bdd[["deme"]]
  # san<-bdd[["dsan"]]
  # rec<-bdd[["drec"]]
  # production = production(rdt1,rdt2,pla_bd,em_bd)
  # rdt = production[[1]]
  # pla = conservation(production[[2]])
  # v= colnames(pla)
  # print(v)
  # sans =resistance(san = san)
  # source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/adventice.R",local = TRUE )
  # adv = resEm
  
  # Merge constraints df
  #ind<-left_join(rdt, sans, by=c("AN", "Zone", "Parcelle", "Sp", "Var"))
  #ind<-left_join(ind, pla, by=c("AN", "Zone", "Parcelle", "Sp", "Var"))
  
}

choose_zone_espece=function(bdd,list_esp,list_zn)
{
  filtre = subset(bdd,Sp.x %in% list_esp & Zone %in% list_zn)
}



# normalisation = function(bdd)
# {
#       prod =bdd[["prod"]]
#       res =bdd[["res"]]
#       cons =bdd[["cons"]]
#       adv =bdd[["adv"]]
#       
#       
#       # normalisation 
#       # remplacer les valeurs manquantes par 0
#       
#       prod[is.na(prod)] <- 0
#       I1_max = max(prod$I1.1)
#       I2_max = max(prod$I1.2)
#       I3_max = max(prod$I1.3)
#       I4_max = max(prod$I1.4)
#       
#       I1.1 = as.vector(prod$I1.1)
#       I1.2 = as.vector(prod$I1.2)
#       I1.3 = as.vector(prod$I1.3)
#       I1.4 = as.vector(prod$I1.4)
#       
#       
#       res[is.na(res)] <- 0
#       I21_max = max( res$I2.1)
#       I22_max = max( res$I2.2)
#       
#       I21 = as.vector(res$I2.1)
#       I22 = as.vector(res$I2.2)
#       
#       cons[is.na(cons)] <- 0
#       I31_max = max( cons$I3.1)
#       I31 = as.vector(cons$I3.1)
#       
#       adv[is.na(adv)] <- 0
#       I51_max = max(adv$I5.1)
#       I51 = as.vector(adv$I5.1)
#       
#       
#       cppFunction('NumericVector norm_i(NumericVector I ,double i_max) {
#           int n = I.size();
#           NumericVector I_n(n);
#           for(int i=0; i<n ; i++)
#                   {
#                     I_n[i] = I[i]/i_max;
#                   }
#       
#         return I_n;
#       }')
#       
#       I1.1 = norm_i(I1.1,I1_max)
#       I1.2 = norm_i(I1.2,I2_max)
#       I1.3 = norm_i(I1.3,I3_max)
#       I1.4 = norm_i(I1.4,I4_max)
#       
#       I21 = norm_i(I21,I21_max)
#       I22 = norm_i(I22,I22_max)
#       
#       I31 = norm_i(I31,I31_max)
#       
#       I51 = norm_i(I51,I51_max)
#       
#       comb<-mutate(comb , I1.1 , I1.2, I1.3, I1.4 , I31, I51)
#       variete = levels( as.factor(comb$Var))
#       return(comb)
#       
# }

# 
# #faire des tests dans le terminal avant de passer à la partie graphique
# #l_esp= list("Da","Dcr")
# l_esp= list("Da")
# 
# # l_esp[["Da"]]="Da"
# # l_esp[["Dcr"]]="Dcr"
# 
# l_zn=list("BT","MG")
# #l_zn=list("MG")
# # l_zn[["GT"]]="GT"
# # l_zn[["BT"]]="BT"
# # l_zn[["BT"]]="MG"
# 
# #scale normalisation
# m=ldf
# v=filtre_all1(bdd = m ,list_esp = l_esp,list_zone = l_zn)
# nor = normalisation(v)
# # fonction de ponderation 
# # pondonderation ( nor, note)
# variete = levels( as.factor(nor$Var))
# vari=as.array(variete)
# 
# size_var = length(variete)
# classement_var = matrix(0, nrow = 28, ncol = 1)
# v=0
# # enlever la boucle for , utiliser length de preference , dplyr 
# for (i in 1:size_var)
# {  
#   v = subset(nor, Var %in% variete[i])
#   v = as.data.frame(v[,6:11])
#   sum_sous_indicateur = dplyr::summarise_all(v,funs(sum))
#   v = sum_sous_indicateur
#   # resultat pour une variete 
#   
#   rendement = sum(v[1,1:4])/4 
#   # resistance à faire
#   conserv= sum(v[1,5])/1 # sera modifié apres
#   advent = sum(v[1,6])/1 # sera modifié apres
#   sum_indicateur = (rendement + conserv + advent) / 3 
#   classement_var[i] = sum_indicateur
#   # print ( sum_indicateur )
# 
# }
# 
# print(classement_var)
# cl=as.data.frame(classement_var)
# vr=as.data.frame(vari)
# c22<-mutate(vr,cl$V1)
# tri_variete=function(nor , variete)
# {
#  
#   print(nor)
#   print(variete)
#   f = subset(nor, Var %in% variete)
#   return(f)
# 
# }
# 
# nor1 = as.matrix(nor)
# 
# lapply(nor1[,1:11] , FUN = tri_variete , variete = vari ) 

# print(v[[2]])
# problèmes rencontrés avec les filtres
#  (Dcr / GT) || (Da / GT) || (Da-Dcr / MG) : resistance 