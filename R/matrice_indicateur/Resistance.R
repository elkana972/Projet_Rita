# # Loading Data
# # source('~/R/R projects/RITA2_VaPaDonF/R/VarName_suite.R')
source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/model.R")
san<-ldf[["dsan"]]
# 
# # #

#   # temp<-anti_join(comb, san, by=c("AN", "Parcelle", "Var", "Sp"="Sp.x", "Zone"))
#   #
#   #
#   # san<-full_join(temp, san, by=c("AN", "Parcelle", "Var", "Sp"="Sp.x", "Zone"))
#   # san$IDM<-ifelse(is.na(san$IDM), 0, san$IDM)
#   #
#   #
#   #
#   # sans<-summarize(group_by(san, AN, Parcelle, Var, Cause_Mal),
#   #                   IDM=max(IDM),
#   #                   JAP_san=max(Date_Obs_Mal_JAP))
#   # sans<-left_join(sans, dplyr::select(dvar, -Var), by=c("Var"="Code"))
#   
#   #        sansDa<-subset(sans, Sp=="Da")
#   #        sansDr<-subset(sans, Sp=="Dr")
#   #       size_sansDa = length(rownames(sansDa))
#   #       size_sansDr = length(rownames(sansDr))
#   #       # #
#   #       print(length(rownames(sansDa)))
#         print(length(rownames(sansDr)))
#         # #
#         # #
#         #print(sansDa)
#         sansDa$Cause_Mal<-ifelse(sansDa$Cause_Mal=="Anthracnose", "I2.1", "I2.2")
#         sansDa<-spread(sansDa, Cause_Mal, IDM)
#         print(sansDa)
#         # #
#         sansDr$Cause_Mal<-ifelse(sansDr$Cause_Mal=="Cur", "I2.1", "I2.2")
#         sansDr<-spread(sansDr, Cause_Mal, IDM)
#         #
#         sans<-dplyr::select(rbind(sansDa, sansDr), AN, Parcelle, Var, Sp, I2.1, I2.2)
#         sans<-dplyr::select(sans,AN, Parcelle, Var, Sp, I2.1, I2.2)
# 
#         sans<-left_join(comb, sans, by=c("AN", "Parcelle", "Var", "Sp"))
#         sans[is.na(sans)] <- 0
# 
# 
#  #    return(sans)
#  #
#  # }
# 
#  # 
#  #  resistance = function(san)
#  #  {
#  # 
#  # san<-ldf[["dsan"]]
#  # temp<-anti_join(comb, san, by=c("AN", "Parcelle", "Var", "Sp"="Sp.x", "Zone"))
#  # san<-full_join(temp, san, by=c("AN", "Parcelle", "Var", "Sp"="Sp.x", "Zone"))
#  # names(san)[names(san)=="Sp.x"]<-"Sp"
#  # san$IDM<-ifelse(is.na(san$IDM), 0, san$IDM)
#  # sans<-dplyr::summarize(group_by(san, AN, Parcelle, Var, Cause_Mal),
#  #                        IDM=max(IDM),
#  #                        JAP_san=max(Date_Obs_Mal_JAP))
#  # sans<-left_join(sans, dplyr::select(dvar, -Var), by=c("Var"="Code"))
#  # sansDa<-subset(sans, Sp=="Da")
#  # 
#  # #print(sansDa)
#  # 
#  # sansDa$Cause_Mal<-ifelse(sansDa$Cause_Mal=="Anthracnose", "I2.1", "I2.2")
#  # sansDa<-spread(sansDa, Cause_Mal, IDM)
#  # 
#  # 
#  # 
#  # sansDr<-subset(sans, Sp=="Dr")
#  # 
#  # 
#  # 
#  # sansDr$Cause_Mal<-ifelse(sansDr$Cause_Mal=="Cur", "I2.1", "I2.2")
#  # sansDr<-spread(sansDr, Cause_Mal, IDM)
#  # sans<-dplyr::select(rbind(sansDa, sansDr), AN, Parcelle, Var, Sp, I2.1, I2.2)
#  # sans<-left_join(comb, sans, by=c("AN", "Parcelle", "Var", "Sp"))
#  # sans[is.na(sans)] <- 0
#  # print(sans)
#  # 
#  # return(sans)
#  # 
#  #   }

resistance = function(san)
{

temp<-anti_join(comb, san, by=c("AN", "Parcelle", "Var", "Sp"="Sp.x", "Zone"))
san<-full_join(temp, san, by=c("AN", "Parcelle", "Var", "Sp"="Sp.x", "Zone"))
san$IDM<-ifelse(is.na(san$IDM), 0, san$IDM)
sans<-dplyr::summarize(group_by(san, AN, Parcelle, Var, Cause_Mal),
                       IDM=max(IDM),
                       JAP_san=max(Date_Obs_Mal_JAP))
sans<-left_join(sans, dplyr::select(dvar, -Var), by=c("Var"="Code"))
sansDa<-subset(sans, Sp=="Da")
sansDa$Cause_Mal<-ifelse(sansDa$Cause_Mal=="Anthracnose", "I2.1", "I2.2")
sansDa<-spread(sansDa, Cause_Mal, IDM)
sansDr<-subset(sans, Sp=="Dr")
sansDr$Cause_Mal<-ifelse(sansDr$Cause_Mal=="Cur", "I2.1", "I2.2")
sansDr<-spread(sansDr, Cause_Mal, IDM)
sans<-dplyr::select(rbind(sansDa, sansDr), AN, Parcelle, Var, Sp, I2.1, I2.2)
sans<-left_join(comb, sans, by=c("AN", "Parcelle", "Var", "Sp"))
sans[is.na(sans)] <- 0
#print(sans)
return(sans)
 
 }
