
# Get the libraries
packs <- c("dplyr", "ggplot2", "tidyr", "viridis", "scales")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)

model = function()
{
  
  
  # Get the data
  # na.strings="NA" : signale les valeurs manquantes
  # strip.white=TRUE : On peut supprimer ces blancs lors de la lecture avec l’argument strip.white en le mettant à TRUE
  emergence <- read.table("~/Dropbox/Stage_cirad/bdd_projet/emergence.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
  parcelle =  read.table("~/Dropbox/Stage_cirad/bdd_projet/parcelle.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
  plantation = read.table("~/Dropbox/Stage_cirad/bdd_projet/plantation.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
  recouvrement = read.table("~/Dropbox/Stage_cirad/bdd_projet/recouvrement.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  rec_pesee = read.table("~/Dropbox/Stage_cirad/bdd_projet/rec_pesee.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  rec_plant = read.table("~/Dropbox/Stage_cirad/bdd_projet/rec_plant.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  sanitaire = read.table("~/Dropbox/Stage_cirad/bdd_projet/sanitaire.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  senescence = read.table("~/Dropbox/Stage_cirad/bdd_projet/senescence.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  stockage = read.table("~/Dropbox/Stage_cirad/bdd_projet/stockage.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  
  liste_bdd = list(emergence,parcelle,plantation,recouvrement,rec_pesee,rec_plant,sanitaire,senescence,stockage)
  return(liste_bdd)
  
  
}
