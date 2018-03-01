
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
  emergence <- read.table("~/data_rita/emergence.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
  parcelle =  read.table("~/data_rita/parcelle.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
  plantation = read.table("~/data_rita/plantation.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
  recouvrement = read.table("~/data_rita/recouvrement.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  rec_pesee = read.table("~/data_rita/rec_pesee.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  rec_plant = read.table("~/data_rita/rec_plant.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  sanitaire = read.table("~/data_rita/sanitaire.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  senescence = read.table("~/data_rita/senescence.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  stockage = read.table("~/data_rita/stockage.csv", header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE) 
  
  liste_bdd = list(emergence,parcelle,plantation,recouvrement,rec_pesee,rec_plant,sanitaire,senescence,stockage)
  return(liste_bdd)
  
  
}

