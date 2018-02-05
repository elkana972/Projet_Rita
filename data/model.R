#cette fonctions permet de choisir la database( fichier excel ) 
#database == 1 (emergence)
#database == 2 (parcelle)
#database == 3 (plantation)
#database == 4 (recouvrement)

# Get the libraries
packs <- c("dplyr", "ggplot2", "tidyr", "viridis", "scales")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)
