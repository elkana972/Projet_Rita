# Loading libraries
packs <- c("plyr", "tidyverse")
InstIfNec<-function (pack) {
    if (!do.call(require,as.list(pack))) {
        do.call(install.packages,as.list(pack))  }
    do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)

# Loading Data
dvar<-read.csv("./data/ListVar.csv", sep=";", dec=",", header=T)
dpar<-read.csv("./data/parcelle.csv", sep=";", dec=",", header=T)
dpla<-read.csv("./data/plantation.csv", sep=";", dec=",", header=T)
deme<-read.csv("./data/emergence.csv", sep=";", dec=",", header=T)
drec<-read.csv("./data/recouvrement.csv", sep=";", dec=",", header=T)
dsan<-read.csv("./data/sanitaire.csv", sep=";", dec=",", header=T)
drdt1<-read.csv("./data/rec_plant.csv", sep=";", dec=",", header=T)
drdt2<-read.csv("./data/rec_pesee.csv", sep=";", dec=",", header=T)
dsen<-read.csv("./data/senescence.csv", sep=";", dec=",", header=T)
dsto<-read.csv("./data/stockage.csv", sep=";", dec=",", header=T)

ldf<-list(dvar, dpla, deme, drec, dsan, drdt1, drdt2, dsen, dsto)
DeleteSpaceToupper<-function(df) {
    df$Var<-str_replace_all(df$Var, fixed(" "), "")
    df$Var<-str_to_upper(df$Var)
    df$Var<-str_trim(df$Var, "right") 
    
    return(df)
}
ldf<-lapply(ldf, DeleteSpaceToupper)

ldv<-vector()
ListVar <- function(df) {
    dfvar<-levels(as.factor(df$Var))
    ldv=append(ldv, dfvar)
    return(ldv)
}
ldv<-lapply(ldf, ListVar)
test <-unique(unlist(ldv))
test