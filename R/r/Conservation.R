# Loading Data
source('~/R/R projects/RITA2_VaPaDonF/R/Production.R', encoding = 'UTF-8')
pla$I3.1<-pla$Nb_Pl_RecF/pmax(pla$NB_Pl_EM, pla$Nb_Pl_RecF)*100
pla<-left_join(comb, select(pla, AN:Var, I3.1), by=c("AN", "Parcelle", "Var"))
