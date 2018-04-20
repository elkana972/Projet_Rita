


server=function(input,output,session)
{
  df<- read.table("~/data_rita/ListVarFichVar.csv", header=TRUE,sep=",", na.strings="NA", dec=",", strip.white=TRUE)
  print(df)
  
  
}