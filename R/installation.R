packs <- c ("plotKML", "raster", "rasterVis", "tidyverse", "lubridate", "XML", "broom", "ggthemes",
            "OpenStreetMap", "maptools", "ggmap", "ggsn",  "plotly", "tmap","shinydashboard","dplyr", "ggplot2", "tidyr", "viridis", "scales","rmarkdown","drc") 
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
g<-lapply(packs, InstIfNec);
sum(unlist(g))-length(packs)
