library("dplyr")
# Load data and indicators
source('~/R/R projects/RITA2_VaPaDonF/R/Resistance.R')
source('~/R/R projects/RITA2_VaPaDonF/R/Conservation.R')

source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/Production.R")
source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/Resistance.R")
source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/matrice_indicateur/Conservation.R")


# Merge constraints df
ind<-left_join(rdt, sans, by=c("AN", "Zone", "Parcelle", "Sp", "Var"))
ind<-left_join(ind, pla, by=c("AN", "Zone", "Parcelle", "Sp", "Var"))

# Scaling Subindicators between 0-1
# TODO scaling by situation in order not to favor variety 
# not evaluated in poor situation (e.g. SF) !!!!!!!!!!!!!!! denis
# TODO polarization of the subindicators !!!!!!!!!!!!! denis
ind[,6:ncol(ind)]<-data.frame(lapply(ind[,6:ncol(ind)], 
                                     function(x) scale(x, center=min(x, na.rm=T), 
                                                       scale=diff(range(x, na.rm=T)))))

# Estimating Indicator scores (mean of subindicators) 
indg<-gather(ind, SubInd, Value, starts_with("I"))
indg<-separate(indg, col=SubInd, into=c("Ind", "SubIn"), sep="\\.")
indgs<-summarize(group_by(indg, AN, Zone, Parcelle, Sp, Var, Ind),
                 IndScores=mean(Value, na.rm=T))

# Multiply each indicator by its weight (coming from farmers prioritization)
# !!!!!!!!!!!!!!!!!!!!! Elkana
prior<-data.frame(Ind=c("I1", "I2", "I3", "I4", "I5"),
                 Prio=c(5,2,0,1,5))
# !!!!!!!!!!!!!!!!
indgs<-left_join(indgs, prior, by="Ind")
indgs$IndScoresPrior<-indgs$IndScores*indgs$Prio

# Estimatin situation score (sum of weighted indicators for each situation)
indgs<-summarize(group_by(indgs, AN, Zone, Parcelle, Sp, Var),
                 SitScore=sum(IndScoresPrior))

# Estimatin Varietal score (mean between situations)
indgs<-summarize(group_by(indgs, Var),
                 VarScore=mean(SitScore, na.rm=T),
                 N=sum(!is.na(SitScore)),
                 SD_VarScore=sd(SitScore, na.rm=T))
