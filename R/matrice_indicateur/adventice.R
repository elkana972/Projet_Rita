# Loading libraries
packs <- c("drc")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)

# Loading Data
#source('/srv/shiny-server/sample-apps/Projet_Rita/R/model.R')


# 1. Duree d'emergence ----------------------
em<-ldf[["deme"]]

# Ajout du nombre de plants plantes au fichier d'emergence
pla<-ldf[["dpla"]]

# 2. Recouvrement ----------------------
rec<-ldf[["drec"]]


# Suppression des modeles errones
DeleteBadModel<- function(fit) {
  ifelse(length(fit$predres)<7, NA, return(fit))
}




# Extraire les infos utiles des modeles
ExtrModelInfo <- function(fit) {
  data.frame(code=paste0(dimnames(fit$indexMat)[2]),
             EM5=ED(fit, 5)[1], EM50=ED(fit, 50)[1],
             I5.1=ED(fit, 90)[1]-ED(fit, 10)[1],
             Slope=summary(fit)$coef[1],
             Emx=summary(fit)$coef[2],
             Tinflex=summary(fit)$coef[3])
}



    plas<-summarize(group_by(pla, AN, Parcelle, Var), 
                    Nb_Pl=sum(NB_P_Parc))
    em<-dplyr::select(em, AN, Parcelle, Var, Plante, Date_Levee_JAP, NB_Lev_Billon)
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
    ems_pr<- dplyr::select(ems_pr, -NB_Lev_Billon)
    ems_pr<-summarize(group_by(ems_pr, AN, Parcelle, Var, Date_Levee_JAP), 
                      N=n(), Np=mean(Nb_Pl))
    ems_pr<-ems_pr[with(ems_pr, order(AN, Parcelle, Var, Date_Levee_JAP)), ]
    ems_pr<-mutate(group_by(ems_pr, AN, Parcelle, Var, Np),
                   Nc=cumsum(N),
                   Start=lag(round(Date_Levee_JAP)),
                   Start=ifelse(is.na(Start), 0, Start),
                   End=as.numeric(round(Date_Levee_JAP)))
    ems_pr<- dplyr::select(ems_pr, -Date_Levee_JAP)
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
    
    # Ajustement des modeles aux 400 situations
    em$cc<-paste(em$AN, em$Parcelle, em$Var, sep="_")
    ccv<-levels(as.factor(em$cc))
    lm<-list()
    i<-0
    for (i in 1:length(levels(as.factor(em$cc)))) {
      tryCatch({
        i<-i+1
        ems<-subset(em, cc==ccv[i])
        m<-drm(N~Start+End, cc, data=ems, fct=L.3(), type ="event",
               lowerl=c(-Inf, 0.1, 0), upperl=c(0,1,Inf),
               control = drmc(trace=F, maxIt=100000))
        lm<-c(lm, list(m))
        return(lm)
      }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    }
    
   
    
    lm2<-lapply(lm, DeleteBadModel)
    lm2<-lm2[lapply(lm2,length)>1]
    
   
    resEm<-lapply(lm2, ExtrModelInfo)
    resEm=do.call(rbind, resEm)
    resEm<-separate(resEm, code, c("AN", "Parcelle", "Var"), sep="_")
    resEm$AN<-as.integer(resEm$AN)
    resEm<-left_join(comb, resEm, by=c("AN", "Parcelle", "Var"))
    
    
   
    
    
    # !!!!!! ajouter 1 0,0 et verifier les données !!!!!!!!!!
    
    
    
    # Modelisation des 400 situations
    rec$cc<-paste(rec$AN, rec$Parcelle, rec$Var, sep="_")
    ccv<-levels(as.factor(rec$cc))
    lm<-list()
    i<-0
    for (i in 1:length(levels(as.factor(rec$cc)))) {
      tryCatch({
        i<-i+1
        recs<-subset(rec, cc==ccv[i])
        m<-drm(pRec_ig~Date_Obs_pRec_JAP, cc, data=recs, fct=L.3(), 
               lowerl=c(-Inf, 10, 0), upperl=c(0,100,240),
               control = drmc(trace=F, maxIt=100000))
        lm<-c(lm, list(m))
        return(lm)
      }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    }

