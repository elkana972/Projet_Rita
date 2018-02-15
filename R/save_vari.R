source("/opt/shiny-server/samples/sample-apps/Projet_Rita/R/model.R")

# Pour la construction de la liste voir le fichier model.R

m=model()

# remarque bdd : modifier le nom de la colonne Variete en Var pour la bdd(plantation) pour faciliter le traitement
colnames(m[[3]])[colnames(m[[3]]) == "Variete"] <- 'Var'

lengt_variety = function(bdd)
{
  bdd = bdd
  l = levels(bdd$Var)
  l=length(l)
 
  print(l)
  return(l)
}

c=lapply(m,lengt_variety) 

# recuperer l'indice ou la valeur maximale est la plus importante
i=which.max(c)

print(i)
#dans la liste des bdd l'indice nous renvoie 1 donc plantation possede le plus de varietes

qualite <- read.table("~/Dropbox/Stage_cirad/bdd_projet/qualité.csv" , header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
recup_var = m[[i]]

# modifier INRACO507 = Orgal ; INRACJ = Jano ; INRAAL51 = Alano
levels(recup_var[,9])[which(levels(recup_var[,9])=="INRACO507")]="Orgal"
levels(recup_var[,9])[which(levels(recup_var[,9])=="INRACJ")]="Jano"
levels(recup_var[,9])[which(levels(recup_var[,9])=="INRAAL51")]="Alano"
levels(recup_var[,9])[which(levels(recup_var[,9])=="Malalaghi")]="Malalagi"

# il y a des elements qui apparaissent 2 fois dans la bdd car les majuscules ne sont pas respectées exemples "Cirad7F"  "CIRAD7F"  
levels(recup_var[,9])[which(levels(recup_var[,9])=="Cirad7F")]="CIRAD7F"

array_qual = levels(qualite$Variété)

array_recup = levels(recup_var$Var)

s=subset ( array_recup, !array_recup %in% array_qual)

#f=factor(append(as.character(v),s))

#f=as.character.factor(f)

# mise en d'un

