library("tidyverse")
# Load data and indicators
source('~/R/R projects/RITA2_VaPaDonF/R/Resistance.R')
source('~/R/R projects/RITA2_VaPaDonF/R/Conservation.R')

# Merge constraints df
ind<-left_join(rdt, sans, by=c("AN", "Zone", "Parcelle", "Sp", "Var"))
ind<-left_join(ind, pla, by=c("AN", "Zone", "Parcelle", "Sp", "Var"))

# Scaling Subindicators between 0-1 for each situation
# scaling by situation in order not to favor variety 
# not evaluated in poor situation (e.g. SF)
ScalingFct<-function(x) { ifelse(diff(range(x, na.rm=T))==0, .5,
                                 (x-min(x, na.rm=T))/diff(range(x, na.rm=T))) }
ind<-mutate_at(group_by(ind, AN, Zone, Parcelle, Sp), vars(contains("I")),
                ScalingFct)


# Polarization of subindicators
indg<-gather(ind, SubInd, Value, starts_with("I"))
NegSubInd<-c("I1.3", "I1.4", "I2.1", "I2.1", "I3.2")
indg$Value<-ifelse(indg$SubInd %in% NegSubInd, 1-indg$Value, indg$Value)

# Estimating Indicator scores (mean of subindicators) 
indg<-separate(indg, col=SubInd, into=c("Ind", "SubIn"), sep="\\.")
indgs<-dplyr::summarize(group_by(indg, AN, Zone, Parcelle, Sp, Var, Ind),
                 IndScores=mean(Value, na.rm=T))

# Multiply each indicator by its weight (coming from farmers prioritization)
# !!!!!!!!!!!!!!!!!!!!! Elkana
prior<-data.frame(Ind=c("I1", "I2", "I3", "I4", "I5"), Prio=c(1,1,1,1,1))
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
