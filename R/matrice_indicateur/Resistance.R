# Loading Data
source('/srv/shiny-server/sample-apps/Projet_Rita/R/model.R')

san<-ldf[["dsan"]]
sans<-summarize(group_by(san, AN, Parcelle, Var, Cause_Mal),
                IDM=max(IDM),
                JAP_san=max(Date_Obs_Mal_JAP))
sans<-left_join(sans, dplyr::select(dvar, -Var), by=c("Var"="Code"))
sansDa<-subset(sans, Sp=="Da")
sansDa$Cause_Mal<-ifelse(sansDa$Cause_Mal=="Anthracnose", "I2.1", "I2.2")
sansDa<-spread(sansDa, Cause_Mal, IDM)
sansDr<-subset(sans, Sp=="Dr")
sansDr$Cause_Mal<-ifelse(sansDr$Cause_Mal=="Cur", "I2.1", "I2.2")
sansDr<-spread(sansDr, Cause_Mal, IDM)
sans<-select(rbind(sansDa, sansDr), AN, Parcelle, Var, Sp, I2.1, I2.2)
sans<-left_join(comb, sans, by=c("AN", "Parcelle", "Var", "Sp"))
sans[is.na(sans)] <- 0
