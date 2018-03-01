# Loading libraries
packs <- c("drc")
InstIfNec<-function (pack) {
    if (!do.call(require,as.list(pack))) {
        do.call(install.packages,as.list(pack))  }
    do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)

# Loading Data
source('~/R/R projects/RITA2_VaPaDonF/R/VarName_suite.R')
em<-ldf[["deme"]]

# Ajout du nombre de plants plantes au fichier d'emergence
pla<-ldf[["dpla"]]
plas<-summarize(group_by(pla, AN, Parcelle, Var), 
                Nb_Pl=sum(NB_P_Parc))
em<-select(em, AN, Parcelle, Var, Plante, Date_Levee_JAP, NB_Lev_Billon)
em<-left_join(em, plas, by=c("AN", "Parcelle", "Var"))

# Preparation du tableau pour les PP
ems_pp<-subset(em, is.na(Plante))
ems_pp<-summarise(group_by(ems_pp, AN, Parcelle, Var, Date_Levee_JAP),
                  Np=mean(Nb_Pl),
                  Nc=sum(NB_Lev_Billon))
ems_pp<-ems_pp[with(ems_pp, order(AN, Parcelle, Var, Date_Levee_JAP)), ]
ems_pp<-mutate(group_by(ems_pp, AN, Parcelle, Var, Np),
               Start=lag(round(Date_Levee_JAP)),
               Start=ifelse(is.na(Start), 0, Start),
               End=as.numeric(round(Date_Levee_JAP)))
ems_pp<-ems_pp %>% group_by(AN, Parcelle, Var, Np) %>% 
    do(data.frame(Nc= c(.$Nc, NA), Start= c(.$Start, NA), End= c(.$End, NA)))
ems_pp<-mutate(group_by(ems_pp, AN, Parcelle, Var, Np),
               Start=ifelse(is.na(Start), lag(End), Start),
               End=ifelse(is.na(End), Inf, End),
               Nc=ifelse(is.na(Nc), Np, Nc),
               N=Nc-lag(Nc),
               N=ifelse(is.na(N), Nc, N))

# Preparation du tableau pour les PR
ems_pr<-subset(em, !is.na(Plante) & !is.na(Date_Levee_JAP))
ems_pr<-select(ems_pr, -NB_Lev_Billon)
ems_pr<-summarize(group_by(ems_pr, AN, Parcelle, Var, Date_Levee_JAP), 
                  N=n(), Np=mean(Nb_Pl))
ems_pr<-ems_pr[with(ems_pr, order(AN, Parcelle, Var, Date_Levee_JAP)), ]
ems_pr<-mutate(group_by(ems_pr, AN, Parcelle, Var, Np),
               Nc=cumsum(N),
               Start=lag(round(Date_Levee_JAP)),
               Start=ifelse(is.na(Start), 0, Start),
               End=as.numeric(round(Date_Levee_JAP)))
ems_pr<-select(ems_pr, -Date_Levee_JAP)
ems_pr<-ems_pr %>% group_by(AN, Parcelle, Var, Np) %>% 
    do(data.frame(Nc=c(.$Nc, NA), Start=c(.$Start, NA), End=c(.$End, NA), 
                  N=c(.$N, NA)))
ems_pr<-mutate(group_by(ems_pr, AN, Parcelle, Var, Np),
               Start=ifelse(is.na(Start), lag(End), Start),
               End=ifelse(is.na(End), Inf, End),
               Nc=ifelse(is.na(Nc), Np, Nc),
               N=ifelse(is.na(N), Np-lag(Nc), N))

# Fusion des df
em<-rbind(ems_pr, ems_pp)
em$cc<-paste(em$AN, em$Parcelle, em$Var, sep="_")
ccv<-levels(as.factor(em$cc))
lm<-list()
i<-0
for (i in 1:length(levels(as.factor(em$cc)))) {
    tryCatch({
        i<-i+1
        ems<-subset(em, cc==ccv[i])
        m<-drm(N~Start+End, cc, data=ems, fct=L.3(), type ="event")
        lm<-c(lm, list(m))
        return(lm)
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}
ExtrModelInfo <- function(fit) {
    data.frame(code=paste0(dimnames(fit$indexMat)[2]),
               Em90=ED(fit, 95)[1]-ED(fit, 5)[1],
               Slope=summary(fit)$coef[1],
               Emx=summary(fit)$coef[2],
               Tinflex=summary(fit)$coef[3])
}
resEm<-lapply(lm, ExtrModelInfo)
resEm=do.call(rbind, resEm)

