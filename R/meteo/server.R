

server=function(input,output,session)
{
  
  observeEvent(input$valider,
               {
                 # Get the data
                 # na.strings="NA" : signale les valeurs manquantes
                 # strip.white=TRUE : On peut supprimer ces blancs lors de la lecture avec l’argument strip.white en le mettant à TRUE
                 df<- read.table("~/data_rita/MeteoGwad_10-16_Lesmond.csv", header=TRUE,sep=";", na.strings="NA", dec=",", strip.white=TRUE)
                 
                 
                 
                 df$date<-as.Date(paste(df$MOIS, df$JOUR, df$AN, sep="/"), format="%m/%d/%Y")
                 
                 # Prepare the data
                 df$UN<-as.numeric(df$UN)
                 df$UX<-as.numeric(df$UX)
                 df$TM<-(df$TN+df$TX)/2
                 df$UM<-(df$UN+df$UX)/2
                 d<-min(df$date)
                 
                 df<-mutate(df, TMM=mean((TN+TX)/2, na.rm=T),UMM=mean( (UN+UX)/2, na.rm=T) )
                 #Mutate adds new variables and preserves existing; transmute drops existing variables.
                 
                 df<-dplyr::mutate(group_by(df, Site, AN), 
                                   RRc=round(cumsum(ifelse(is.na(RR), 0, RR)))/1000,
                                   PARc=round(cumsum(ifelse(is.na(PAR), 800, PAR)))/100,
                                   Day=seq_along(RR), RRmis=sum(is.na(RR)),
                                   Tmis=sum(is.na(TN))+sum(is.na(TX)),
                                   Umis=sum(is.na(UN))+sum(is.na(UX)),
                                   PARmis=sum(is.na(PAR)))
                 
                 df$Saison<-ifelse(df$MOIS %in% c(1,2,3,4), "Seche", "Humide")
                 df$CommonDate <- as.Date(paste0("2000-",format(df$date, "%j")), "%Y-%j")
                 
                 RRs<-dplyr::summarize(group_by(df, Site, AN), 
                                       x=max(CommonDate), y=max(RRc), labs=round(max(RRc), 2),
                                       labsPAR=round(max(PARc),2),  RRmis=sum(is.na(RR)),
                                       PARmis=sum(is.na(PAR)), yPAR=max(PARc))
                 RRs$lab<-paste(RRs$AN, ": ",  RRs$labs, "m (", RRs$RRmis, " missing data)")
                 RRs$labPAR<-paste(RRs$AN, ": ",  RRs$labsPAR, "(", RRs$PARmis, " missing data)")
                 
                 choix = input$choix_graph
                 an = input$an

                 # Subset by user's choice
                 choosenAN<-an # ici il faut faire le lien avec le choix de l'utilisateur
                 dfp<-subset(df, AN==choosenAN)
                 if(choix=="Température")
                 {
                   
                   # 1. Temperature --------------------------------
                   choosenVAR<-"Temperature" # ici il faut faire le lien avec le choix de l'utilisateur
                   dfp$lab<-paste(dfp$Site, "(", dfp$Tmis, " missing data)")
                   plot_1 = ggplot(dfp, aes(date, ymin = TN, ymax = TX, 
                                            color = (TN+TX)/2)) + 
                     geom_linerange(size = 1.3, alpha = 0.75) +
                     scale_color_viridis("Température (°C)", option = "A") +
                     scale_x_date(labels = date_format("%b"), breaks = date_breaks("month")) + 
                     ylim(10, 35) + 
                     coord_polar() + theme_minimal() +
                     theme(legend.position = "bottom")+
                     theme(text = element_text(size=20))+
                     facet_grid(.~lab) 
                   
                   output$titre = renderText(
                     {
                       "Gamme de température journalière en Guadeloupe (Duclos and Godet)"
                     }
                   )
                    output$graphique= renderPlot(plot_1 )
                    
                    output$description = renderText(
                      {
                        "Ce graphique montre les températures journalières à Godet (Petit-Canal, Grande-Terre) 
                et Duclos (Petit-Bourg, Basse-Terre). Chaque barre représente l'écart entre la température
                maximale et minimale d'une journée. On peut ainsi voir les périodes fraîches (en violet foncé)
                et chaudes (en jaune pâle)."
                      }
                    )
                 }
                 else if(choix=="Pluviométrie")
                 {
                   # 2. Rainfall ------------------------------------
                   choosenVAR<-"Rainfall" # ici il faut faire le lien avec le choix de l'utilisateur
                   plot_2 = ggplot(aes(x=CommonDate, y=RRc, color=factor(AN)), data=df)+
                     geom_line()+
                     geom_line(data=dfp, aes(x=CommonDate, y=RRc, color=factor(AN)), size=2)+
                     theme_bw(base_size = 18)+
                     theme(legend.position="none")+
                     ylab("Pluviométrie cumulée (m)")+
                     labs(
                          x = NULL,
                          subtitle="Données issues de la plateforme INRA CLIMATIK") +
                     facet_grid(~Site)+ 
                     geom_text(aes(x, y, label=lab, group=NULL), data=RRs, hjust=-.1, vjust=0.2)+
                     theme(axis.title.x = element_blank())+
                     scale_x_date(labels = function(x) format(x, "%d-%b"),
                                  date_breaks = "1 month",
                                  limits=as.Date(c('2000-01-01','2001-05-01')))+
                     theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,
                                                      color=c(rep("black", 12), rep("white",6))))+
                     theme(text = element_text(size=20))
                     
                   output$titre = renderText(
                     {
                       "Comparaison de la pluviométrie cumulée annuelle en Guadeloupe (Duclos and Godet)"
                     })
                   output$graphique= renderPlot(plot_2)
                   
                   output$description = renderText(
                     {
                       "Ce graphique montre l'évolution de la pluviométrie cumulée à Godet (Petit-Canal, Grande-Terre) 
       et Duclos (Petit-Bourg, Basse-Terre). La courbe en gras montre la pluviométrie de l'année choisie.
       Dans la marge la pluviométrie totale de chaque année est mentionnée en mètres."
                     }
                   )
                   
                 }
                 else if(choix=="Humidité")
                 {
                   # 3. Humidity -----------------------------------------
                   choosenVAR<-"Humidity" # ici il faut faire le lien avec le choix de l'utilisateur
                   dfp$lab<-paste(dfp$Site, "(", dfp$Umis, " missing data)")
                   plot_3=ggplot(dfp, aes(date, ymin = UN, ymax = UX, 
                                   color = (UN+UX)/2)) + 
                     geom_linerange(size = 1.3, alpha = 0.75) +
                     scale_color_viridis("Humidity (%)", option = "A") +
                     scale_x_date(labels = date_format("%b"), breaks = date_breaks("month")) + 
                     labs(
                          x = NULL, y = NULL,
                          subtitle="Données issues de la plateforme INRA CLIMATIK") +
                     coord_polar() + theme_minimal() +
                     theme(legend.position = "bottom")+
                     theme(text = element_text(size=20))
                     facet_grid(.~lab)
                   output$titre = renderText(
                     {
                       "Gamme d'humidité journalière en Guadeloupe (Duclos and Godet)"
                     })
                   output$graphique= renderPlot(plot_3)
                   output$description = renderText(
                     {
                       "Ce graphique montre la gamme d'humidité de l'air journalières à Godet (Petit-Canal, Grande-Terre) 
       et Duclos (Petit-Bourg, Basse-Terre). Chaque barre représente l'écart entre l'humidité
       maximale et minimale d'une journée. On peut ainsi voir les périodes sèches (en violet foncé)
       et humides (en jaune pâle)."
                     }
                   )
                 }
                 else if(choix=="Radiation")
                 {
                   choosenVAR<-"Radiation" # ici il faut faire le lien avec le choix de l'utilisateur
                  
      
                   plot_4 = ggplot(aes(x=CommonDate, y=PARc, color=factor(AN)), data=df)+
                     geom_line()+
                     geom_line(data=dfp, aes(x=CommonDate, y=PARc, color=factor(AN)), size=2)+
                     theme_bw(base_size = 18)+
                     theme(legend.position="none")+
                     ylab("Rayonnement photosynthétique util cumulé (MJ/m²)")+
                     labs(
                          x = NULL,
                          subtitle="Données issues de la plateforme INRA CLIMATIK"
                          ) +
                     facet_grid(~Site)+ 
                     geom_text(aes(x, yPAR, label=labPAR, group=NULL), data=RRs, hjust=-.1, vjust=0.2)+
                     theme(axis.title.x = element_blank())+
                     scale_x_date(labels = function(x) format(x, "%d-%b"),
                                  date_breaks = "1 month",
                                  limits=as.Date(c('2000-01-01','2001-05-01')))+
                     theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,
                                                      color=c(rep("black", 12), rep("white",6))))+
                     scale_y_continuous(trans = boxcox_trans(2))
                   output$titre = renderText(
                     {"Comparaison du rayonnement cumulé en Guadeloupe (Duclos and Godet)"
                      })
                    output$graphique= renderPlot(plot_4)
                    output$description = renderText(
                      {
                        "Ce graphique montre l'évolution du rayonnement photosynthétique util cumulée 
à Godet (Petit-Canal, Grande-Terre)  et Duclos (Petit-Bourg, Basse-Terre).
La courbe en gras montre le rayonnement cumulé de l'année choisie. 
                        Dans la marge le rayonnement total de chaque année est mentionné."
                      }
                    )
                   
                 }
                 
                 
               }
               )
  
  observe({
    gr= input$choix_graph
    an= input$an
    t = length(an)
      cat(" gr ",gr," an",as.numeric(an))
         })
  
  
}