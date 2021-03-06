# Loading libraries
packs <- c("plyr", "tidyverse", "lubridate")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)

# Loading Data
# Loading Data
dvar<-read.csv("~/data_rita/ListVar.csv", sep=";", dec=",", header=T,fileEncoding = "latin1")
dpar<-read.csv("~/data_rita/parcelle.csv", sep=";", dec=",", header=T,fileEncoding = "latin1")
dpla<-read.csv("~/data_rita/plantation.csv", sep=";", dec=",", header=T,fileEncoding = "latin1")
deme<-read.csv("~/data_rita/emergence.csv", sep=";", dec=",", header=T,fileEncoding = "latin1")
drec<-read.csv("~/data_rita/recouvrement.csv", sep=";", dec=",", header=T,fileEncoding = "latin1")
dsan<-read.csv("~/data_rita/sanitaire.csv", sep=";", dec=",", header=T,fileEncoding = "latin1")
drdt1<-read.csv("~/data_rita/rec_plant.csv", sep=";", dec=",", header=T,fileEncoding = "latin1")
drdt2<-read.csv("~/data_rita/rec_pesee.csv", sep=";", dec=",", header=T,fileEncoding = "latin1")
dsen<-read.csv("~/data_rita/senescence.csv", sep=";", dec=",", header=T,fileEncoding = "latin1")
dsto<-read.csv("~/data_rita/stockage.csv", sep=";", dec=",", header=T,fileEncoding = "latin1")


dvar<-dplyr::select(dvar, Sp, Code, Var)
dvar$Var<-as.character(dvar$Var)
dvar$Code<-as.character(dvar$Code)
ldf<-list(dpla=dpla, deme=deme, drec=drec, dsan=dsan, drdt1=drdt1, drdt2=drdt2,
          dsen=dsen, dsto=dsto)

# Fixer un nom de variete unique dans chaque BDD
FixVar<-function(df) {
  df$Var<-str_replace_all(df$Var, fixed(" "), "")
  df$Var<-str_to_upper(df$Var)
  df$Var<-as.character(str_trim(df$Var, "right"))
  df$Var<-ifelse(df$Var=="MALALAGHI", "MALALAGI", df$Var)
  df<-left_join(df, dvar, by="Var")
  df<-mutate(df, Var=ifelse(is.na(Code), Var, Code))
  return(df)
}
ldf<-lapply(ldf, FixVar)

# Fixer les dates 
FixDate<-function(df) {
  df %>%  mutate_at(vars(contains('Date')), funs(dmy))
}
ldf<-lapply(ldf, FixDate)

# Ajout de la Date de Plantation et calcul des JAP
dfs<-dplyr::summarize(group_by(ldf[["dpla"]], AN, Parcelle), 
                      Date_Pl=mean(Date_Plant), 
                      Densite=1/(mean(Dist_Billon)*mean(Dist_Ligne)))
FixJAP<-function(df) {
  df<-left_join(df, dfs, by=c("AN", "Parcelle"))
  df %>%  mutate_at(vars(contains('Date')), funs(JAP=.-Date_Pl))
}
ldf<-lapply(ldf, FixJAP)

# Fixer les zones 
GTl<-c("AB", "Godet", "LM", "MO", "SF")
FixZone<-function(df) {
  df$Zone<-ifelse(df$Parcelle %in% GTl, "GT",
                  ifelse(df$Parcelle=="GB", "MG", "BT"))
  return(df)
}
ldf<-lapply(ldf, FixZone)

# Creation d'un df avec toutes les combinaisons AN, Parcelle, Var
ldv<-vector()
ListCombi <- function(df) {
  df$Combi<-paste(df$AN, df$Zone, df$Parcelle, df$Var, sep="_")
  comb<-levels(as.factor(df$Combi))
  ldv=append(ldv, comb)
  return(ldv)
}
ldv<-lapply(ldf, ListCombi)
comb <-as.data.frame(unique(unlist(ldv)))
comb<-separate(comb, 1, c("AN", "Zone", "Parcelle", "Var"))
comb<-left_join(comb, dplyr::select(dvar, -Var), by=c("Var"="Code"))
comb$AN<-as.integer(comb$AN)





# dvar<-dplyr::select(dvar, Sp, Code, Var)
# 
# dvar$Var<-as.character(dvar$Var)
# dvar$Code<-as.character(dvar$Code)
# ldf<-list(dpla=dpla, deme=deme, drec=drec, dsan=dsan, drdt1=drdt1, drdt2=drdt2,
#           dsen=dsen, dsto=dsto)
# 
# # Fixer un nom de variete unique dans chaque BDD
# FixVar<-function(df) {
#   df$Var<-str_replace_all(df$Var, fixed(" "), "")
#   df$Var<-str_to_upper(df$Var)
#   df$Var<-as.character(str_trim(df$Var, "right"))
#   df$Var<-ifelse(df$Var=="MALALAGHI", "MALALAGI", df$Var)
#   df<-left_join(df, dvar, by="Var")
#   df<-mutate(df, Var = ifelse(is.na(Code), Var, Code))
#   return(df)
# }
# ldf<-lapply(ldf, FixVar)
# 
# # Fixer les dates 
# FixDate<-function(df) {
#   df %>%  mutate_at(vars(contains('Date')), funs(dmy))
# }
# ldf<-lapply(ldf, FixDate)
# 
# # Ajout de la Date de Plantation et calcul des JAP
# dfs<-dplyr::summarize(group_by(ldf[["dpla"]], AN, Parcelle), 
#                       Date_Pl=mean(Date_Plant), 
#                       Densite=1/(mean(Dist_Billon)*mean(Dist_Ligne)))
# FixJAP<-function(df) {
#   df<-left_join(df, dfs, by=c("AN", "Parcelle"))
#   df %>%  mutate_at(vars(contains('Date')), funs(JAP=.-Date_Pl))
# }
# ldf<-lapply(ldf, FixJAP)
# 
# 
# # Creation d'un df avec toutes les combinaisons AN, Parcelle, Var
# ldv<-vector()
# ListCombi <- function(df) {
#   df$Combi<-paste(df$AN, df$Parcelle, df$Var, sep="_")
#   comb<-levels(as.factor(df$Combi))
#   ldv=append(ldv, comb)
#   return(ldv)
# }
# ldv<-lapply(ldf, ListCombi)
# comb <-as.data.frame(unique(unlist(ldv)))
# comb<-separate(comb, 1, c("AN", "Parcelle", "Var"))
# comb<-left_join(comb, dplyr::select(dvar, -Var), by=c("Var"="Code"))
# comb$AN<-as.integer(comb$AN)
# 
# #comb = dplyr::mutate(comb,Zone)
# comb<-mutate(comb , Zone = (
#   ifelse( comb$Parcelle=="AB", "GT",
#           (ifelse( comb$Parcelle=="BA", "BT",
#           ifelse( comb$Parcelle=="Godet", "GT",
#           ifelse( comb$Parcelle=="GO", "BT",
#           ifelse( comb$Parcelle=="Duclos", "GT",
#           ifelse( comb$Parcelle=="GB", "MG",
#           ifelse( comb$Parcelle=="LA", "BT",
#           ifelse( comb$Parcelle=="LM", "GT",
#           ifelse( comb$Parcelle=="MO", "GT",
#           ifelse( comb$Parcelle=="Roujol", "BT",
#           ifelse( comb$Parcelle=="SF", "GT",""))))))))))))))

