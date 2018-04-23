
df<- read.table("~/data_rita/ListVarFichVar.csv", header=TRUE,sep=",", na.strings="NA", dec=",", strip.white=TRUE)


server=function(input,output,session)
{
 
  df$Fiche.variétales = sapply(df$Fiche.variétales, function(x) toString(tags$a(href=paste0("http://riberal.cirad.fr/sample-apps/Projet_Rita/data/fiche_varietale//", x), x)))
  colnames(df)[6] = "Code CRB-PT"
  colnames(df)[7] = "Fiche variétales"
  print(df)
  output$pdf = renderDataTable(expr = datatable(df, escape=6 ), options = list(autoWidth = T))
  #datatable(df, escape = FALSE)
  
  
}