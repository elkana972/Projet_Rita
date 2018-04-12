library(shinydashboard)
library(shinyjs)
dashboardPage(
  dashboardHeader(disable = TRUE),
  dashboardSidebar(disable =TRUE),
  dashboardBody(
    tags$style(type="text/css", "img { max-width:100%; height: auto; }"),
    fluidRow(
    box(
      width = 12 , status = "info",
      tags$img(src="presentation.jpg"),
      tags$h2("Prodimad"),
      tags$h3("Production, diffusion et promotion de variétés d’ignames et de madères performantes"),
      tags$a(href="http://coatis.rita-dom.fr/guadeloupe/wakka.php?wiki=RechercheFacette&q=prodimad&facette&facette=","Projet PRODIMAD"),
      tags$h3("Objectifs"),
      tags$div(
        tags$p("L’enjeu global de ce projet est d’assurer un approvisionnement constant et à moindre coût de semences produites localement pour des variétés performantes non présentes sur le marché concurrentiel de l’import. Il est également de proposer et promouvoir un portefeuille variétal diversifié d’ignames et de madères aux producteurs, gage de pérennisation du dispositif de production de plants de qualité. Les objectifs spécifiques sont les suivants:"), 
        tags$p("1) Assurer à court terme la multiplication des variétés innovantes sélectionnées dans le projet EVA-transfert par des pratiques conventionnelles et les diffuser aux producteurs. "), 
        tags$p("2) Proposer des solutions techniques innovantes permettant la mise en place d’un dispositif de production de semences de qualité qui soit pérenne et économiquement viable. "),
        tags$p("3) Développer le portefeuille variétal et en assurer la promotion dans un cadre participatif. ")
      ),
      tags$h3("Description"),
      tags$div(
        tags$p("Afin d’atteindre les objectifs décrits précédemment, 3 actions opérationnelles ont été définies :"),
        tags$p("Action 1. Diffusion et multiplication des variétés performantes. Cette action, à court terme, vise à présenter et diffuser le plus rapidement possible les variétés performantes sélectionnées et retenues par les producteurs dans le cadre du projet EVA-transfert. 
Afin d’accompagner les producteurs ou les conseillers agricoles dans le choix des variétés les mieux adaptées à leur zone de production, un outil sera développé, sous forme d'application informatique interactive. Il s’agira d’une application d’aide au choix des variétés à destination des producteurs et de leurs interlocuteurs directs.
Lien vers l’outil d’aide au choix des variétés ")
      ),
      tags$p("Action 2. Mise en place d’un dispositif de production et diffusion de semences de qualité 
Cette action, à moyen terme, vise à mettre en place un dispositif pérenne et économiquement viable de production de semences de qualité, adapté aux contraintes techniques et financières des producteurs via (i) la conservation des variétés d’intérêt majeur pour les producteurs et fourniture de matériel végétal sain pour les expérimentations et (ii) la mise au point de techniques et solutions innovantes pour la multiplication de matériel végétal de qualité. La production et la diffusion de semences de qualité implique la nécessité de disposer de matériel végétal initial assaini. L’objectif est de conserver à long terme en culture in vitro les variétés sélectionnées par les producteurs. La production de semences de qualité et à moindre coût nécessite la mise au point de techniques, méthodes et systèmes de culture adaptés au contexte de production local. Cette tâche consiste à évaluer en conditions réelles des innovations permettant d’assurer la production à un coût acceptable par les producteurs de semences de qualité."
             ),
    tags$p("Action 3. Développement, caractérisation et promotion d’un portefeuille de nouvelles variétés d’ignames et de madères 
Cette action vise à élargir l’offre variétale et présenter aux agriculteurs, dans leurs différentes zones de production, les nouvelles variétés performantes d’ignames et de madères introduites ou créées localement par la recherche. Cette action se décline en trois tâches : 
La caractérisation, sélection et multiplication pour le dispositif multilocal, de nouvelles variétés d’ignames et de madères. La caractérisation et la sélection de nouveaux hybrides d’ignames et de madères seront conduites en station expérimentale, en interaction avec les producteurs.
La mise en place d’un dispositif multi-local et participatif de démonstration chez les producteurs. Les variétés performantes n’ont pas le même comportement dans chaque zone de production géographique et ne correspondent pas toutes aux mêmes attentes des producteurs. Il est donc indispensable de présenter ces variétés et de les comparer dans des parcelles mises en place chez les producteurs dans les principales zones de production de celles-ci.
L’élaboration et la diffusion du catalogue variétal. L'objectif est de porter à la connaissance des agriculteurs des informations sur les variétés offrant le meilleur potentiel en Guadeloupe (variétés traditionnelles et nouveaux hybrides). 
")
    )
    )
    
    
    
    
  )
)



