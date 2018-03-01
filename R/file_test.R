information_user <- read.table("/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv" , header=TRUE, sep=";", na.strings="NA", dec=",", strip.white=TRUE)  
l=length(row.names( information_user  ))

inform_usr=  write.table(information_user,file="/srv/shiny-server/sample-apps/Projet_Rita/output/information_user.csv",row.names=FALSE,  sep = ";",dec = "," , na = "0")
print(inform_usr)
