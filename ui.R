#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(shinydashboard)

shinyUI(
  navbarPage(
    title = "Les 8000m",
    
    # Choisir le thème
    theme = shinytheme("sandstone"),
    
    # Inclure du CSS
    includeCSS("www/style.css"),
    
    ###################################
    ##### Première page : Accueil #####
    ###################################
    
    tabPanel(title = "Accueil",
             fluidPage(
               
               # Afficher et centrer le titre
               tags$div(
                 class = "centered",
                 h1(HTML("<b>Explorez les sommets : Découvrez les défis des plus de 8000m</b>"))
               ),
               
               tags$hr(),
               
               # Afficher une image + centrer et espacer l'image
               tags$div(
                 class = "centered espace-entre-texte-et-image",
                 img(src = "alpinisme.jpeg", width = 500, height = 300)
               ),
               
               tags$hr(),
               
               # Description de la page + justifier le texte
             tags$div(
               class = "justifier-texte",
               p("Bienvenue sur notre application dédiée à l'analyse des accidents d'alpinisme. Cette application vise à explorer et comprendre les incidents survenus dans le monde de l'alpinisme, offrant un certain nombre informations."),
               p("L'alpinisme est une activité exaltante qui offre des défis uniques et des paysages époustouflants. Cependant, cette pratique comporte également des risques considérables. Chaque année, des alpinistes du monde entier se lancent dans des expéditions pour gravir des sommets emblématiques, tels que les huit mille mètres. Les risques inhérents à l'alpinisme sont multiples, notamment les avalanches, les chutes, les maladies liées à l'altitude et les conditions météorologiques extrêmes. Ces dangers peuvent entraîner des accidents graves, voire mortels."),
               p("Idées de tâches intéressantes :"),
               tags$ul(
                 tags$li("Analyser les tendances et les patterns des décès sur les différents sommets de huit mille mètres."),
                 tags$li("Enquêter sur les causes de décès en relation avec des montagnes ou des nationalités spécifiques."),
                 tags$li("Comparer la mortalité des différents alpinistes en fonction de leur nationalité ou des montagnes choisies."),
                 tags$li("Concevoir un modèle pour prédire la cause de décès en fonction du mois et de la montagne choisie.")
               )
             )
          )), ##### Fin du tabPanel #####
    
    #########################################
    ##### Deuxième page : Les montagnes #####
    #########################################
    
    tabPanel(title = "Les montagnes",
             fluidPage(
               
               # Titre de la page
               h1(HTML("<b>Présentation des montagnes</b>")),
               
               # Description de la page
               tags$div(
                 class = "justifier-texte",
                 p(HTML("Notre objectif ici est de vous permettre de situer les sommets majestueux à travers une carte interactive. Chaque montagne est accompagnée d'une image et d'une description détaillée, vous offrant une opportunité unique de mieux la connaître et de comprendre les risques spécifiques associés à chaque pic. <br>
                        <br>Explorez la carte pour visualiser l'emplacement géographique des montagnes, et plongez-vous dans leurs caractéristiques distinctives en cliquant sur la montagne qui vous intéresse. Chaque montagne a son histoire, sa topographie unique, et ses défis particuliers pour les alpinistes courageux. <br>
                        <br>De plus, découvrez les liens de parenté entre les montagnes à travers notre graphe dirigé. Ces connexions vous permettent de comprendre les relations géographiques et géologiques entre les sommets, offrant une perspective fascinante sur la formation et l'évolution de ces majestueux massifs."))
               ),
               tags$hr(),
               
               # Pouvoir switcher entre carte et réseau de montagne
               tabsetPanel(
                 tabPanel("Carte", leafletOutput("carte_8000"), 
                          
                          # Espace pour afficher l'image et la description de la montagne
                          uiOutput("wellPanel")),
                 
                 tabPanel("Réseau", plotOutput("reseau"),
                          
                          tags$div(
                            class = "justifier-texte",
                            p(HTML("<b> Explication : </b> Le concept de montagne parent est une notion en topographie utilisée pour déterminer la proéminence d'un sommet. Un pic parent se réfère à une montagne plus élevée qui se trouve généralement à proximité du sommet considéré, bien que ce ne soit pas toujours le cas. Le choix du pic parent dépend de divers critères spécifiques à chaque situation. Chaque sommet possède ainsi un pic parent, à l'exception des sommets qui sont les points culminants d'une île ou d'un continent."))
                          ))), ##### Fin du tabsetPanel #####
          ) # Fin du fluidPage
          ), # Fin du tabPanel (page 2)
    
    ##########################
    ##### Page Accidents #####
    ##########################
    
               tabPanel("Analyse des accidents",
                        
                        
                        # Titre de la page Analyse
                        h1(HTML("<b>Analyse descriptive des accidents</b>")),
                        
                        tabsetPanel(
                          tabPanel("Par montagne",
                                   
                                   fluidRow(
                                     
                                     # Colonne de gauche (choisir montagne)
                                     column(width = 3, wellPanel(
                                       selectInput(inputId = "choix_montagne", label = "Sélectionner une montagne", choices = c("", sort(unique(data_total$Mountain)))),
                                       
                                       fluidRow(
                                         column(width = 6, align = "left", actionButton("do_accident_montagne", "Rechercher", class = "btn-block")),
                                         column(width = 6, align = "right", actionButton("res_accident_montagne", "Réinitialiser", class = "btn-block"))
                                       ) ##### Fin du fluidRow
                                     ), ##### Fin du wellPanel
                                     # WellPanel pour afficher le nombre de morts
                                     wellPanel(
                                       h4(style = "font-weight: bold;", "Nombre de morts   ", icon("skull", class = "fa-2x")),
                                       textOutput("nombre_morts_montagne")  
                                     ),
                                     
                                     # WellPanel pour afficher la cause la plus représentée
                                     wellPanel(
                                       h4(style = "font-weight: bold;","Cause la/les plus représentée(s)   ", icon("exclamation-triangle", class = "fa-2x")
                                       ),
                                       textOutput("cause_repr_montagne")
                                     )
                                     ), ##### Fin de column
                                     
                                     # Colonne de droite (affichage graphique)
                                     column(width = 9, wellPanel(
                                       h3(HTML("<b style='margin-top: 20px;'>Evolution du nombre d'accidents sur la montagne</b>")),
                                       amChartsOutput("accidents_montagne"),
                                       
                                       tags$div(
                                         class = "justifier-texte", style = "margin-top: 20px;",
                                         p(HTML("<b>Interprétation :</b> A partir des années 1970, on observe une augmentation progressive du nombre d'accidents d'alpinisme, vraisemblablement due à la popularisation de cette pratique. Bien que le nombre d'alpinistes tentant de conquérir les plus hauts sommets du monde continue d'augmenter dans les années 2000, le nombre d'accidents semble diminuer. Cette tendance peut être partiellement expliquée par l'amélioration du matériel (tels que l'utilisation de bouteilles d'oxygène, des crampons de meilleure qualité, des manteaux isolants plus performants, etc.) et par une meilleure préparation des alpinistes. En effet, l'alpinisme de haut niveau ne peut être entrepris du jour au lendemain par n'importe qui. Atteindre le sommet des plus hauts pics nécessite des mois, voire des années, d'entraînement. De plus, l'accès à ces sommets est réglementé, avec l'obligation pour les alpinistes de démontrer leur expérience et débourser une certaine somme. Par exemple pour obtenir le permis pour l'Everest, il faut avoir déjà atteint un sommet de plus de 6500 mètres, recourir à un guide local, et s'acquitter de 11 000$. Enfin, l'escalade de ces sommets implique des coûts significatifs, avec des dépenses allant de 20 000$ à 200 000$ pour les sommets de plus de 8000 mètres, incluant le billet d'avion, l'assurance, l'achat d'équipement spécialisé, les services d'une agence, etc."))
                                       )),
                                       
                                       fluidRow(
                                         column(width = 6, wellPanel(
                                           h3(HTML("<b style='margin-top: 20px;'>Top5 des nationalités les plus représentées</b>")),
                                           amChartsOutput("barplot_nat"),
                                           
                                           tags$div(
                                             class = "justifier-texte", style = "margin-top: 20px;",
                                             p(HTML("<b>Interprétation :</b> À l'échelle mondiale, les Népalais sont de loin les plus touchés par les accidents d'alpinisme. Cette situation s'explique principalement par la présence des Sherpas, un peuple habitant les régions montagneuses de l'Himalaya au Népal. Pour les alpinistes et les occidentaux, le terme 'Sherpa' est souvent utilisé pour désigner les porteurs et les guides lors d'une expédition en haute altitude. Étant indispensables lors de ces expéditions, les Népalais représentent la nationalité la plus impliquée dans les expéditions et sont logiquement plus exposés aux accidents. Cependant, si l'on se penche sur la répartition des accidents selon les montagnes, ce classement change. Les Népalais, qui étaient en tête pour l'ensemble des montagnes, n'apparaissent plus dans le classement pour d'autres pics. En effet, la majorité de leurs accidents se produisent sur l'Everest (environ la moitié), ce qui s'explique aisément : les autorités népalaises exigent que les alpinistes prennent un guide népalais pour gravir l'Everest. D'autres nationalités qui n'étaient pas présentes dans le classement global apparaissent dans le classement des accidents spécifiques à certaines montagnes. Ainsi, on peut supposer l'existence d'une corrélation entre la montagne et la nationalité des alpinistes."))
                                           ))),
                                         
                                         column(width = 6, wellPanel(
                                           h3(HTML("<b style='margin-top: 20px;'>Répartition des causes</b>")),
                                           amChartsOutput("radar_montagne"),
                                           
                                           tags$div(
                                             class = "justifier-texte", style = "margin-top: 20px;",
                                             p(HTML("<b>Interprétation :</b> En ce qui concerne la répartition des causes d'accidents, elle suit à peu près la même tendance que celle observée pour la nationalité des alpinistes. Globalement, les avalanches, les chutes et les maladies représentent la majorité des accidents. Cependant, cette répartition varie lorsque l'on se penche sur des montagnes spécifiques. Par exemple, pour le K2, la plupart des accidents sont dus à des chutes. Ce sommet est réputé pour sa difficulté et ses pentes abruptes, ce qui rend l'escalade particulièrement périlleuse. Pour le Dhaulagiri I, la majorité des accidents sont causés par des avalanches. En revanche, pour le Gasherbrum I, les accidents sont principalement des disparitions, tandis que pour le Makalu, c'est la maladie, et pour l'Everest, on observe une combinaison d'avalanches, de chutes et de maladies. Il est possible que pour l'Everest, la diversité des profils d'alpinistes attirés par cette montagne entraîne une multiplicité de causes d'accidents. Ainsi, on peut envisager l'existence d'une corrélation entre la montagne et la cause des accidents."))
                                           )))
                                       )
                                     )
                                     
                                   ) ##### Fin du fluidRow
                          ), ##### Fin du tabPanel montagne
                          
                          tabPanel("Par nationalité", 
                                   
                                   wellPanel(
                                     tags$div(
                                       class = "jusitifier-texte",
                                       p(HTML("<b>Interprétation :</b> L
                                              es graphiques pour la nationalité des alpinistes impliqués dans les accidents d'alpinisme est similaire à celle des graphiques pour la répartition des accidents par montagne. Dans les deux cas, nous examinons la répartition des accidents en fonction d'une caractéristique spécifique : soit la nationalité des alpinistes, soit la montagne sur laquelle les accidents se sont produits. En ce qui concerne la carte, elle offre une représentation visuelle encore plus intuitive de la répartition des accidents par pays. En un coup d'œil, on peut voir quels pays ont été les plus touchés par les accidents d'alpinisme."))
                                     )
                                   ),
                                   
                                   fluidRow(
                                     
                                     # Colonne gauche (choisir nationalité)
                                     column(width = 3, wellPanel(
                                       selectInput(inputId = "choix_nat", label = "Sélectionner une nationalité", choices = c("", sort(unique(data_total$region)))),

                                       fluidRow(
                                         column(width = 6, align = "left", actionButton("do_accident_nat", "Rechercher", class = "btn-block")),
                                         column(width = 6, align = "right", actionButton("res_accident_nat", "Réinitialiser", class = "btn-block"))
                                       ) ##### Fin du fluidRow
                                     ), ##### Fin du wellPanel
                                     
                                     # WellPanel pour afficher le nombre de morts
                                     wellPanel(
                                       h4(style = "font-weight: bold;", "Nombre de morts   ", icon("skull", class = "fa-2x")),
                                       textOutput("nombre_morts_nat")  
                                     ),
                                     
                                     # WellPanel pour afficher la cause la plus représentée
                                     wellPanel(
                                       h4(style = "font-weight: bold;","Cause la/les plus représentée(s)   ", icon("exclamation-triangle", class = "fa-2x")
                                       ),
                                       textOutput("cause_repr_nat") 
                                     )
                                  ),##### Fin de column #####
                                     
                                  # Colonne de droite (affichage des graphiques)
                                     column(width = 9, wellPanel(
                                       h3(HTML("<b style='margin-top: 20px;'>Cartographie des accidents selon la
                                               nationalité</b>")),
                                       leafletOutput("carte_accident_nationalite")),
                                     
                                     fluidRow(
                                       column(width = 6, wellPanel(
                                         h3(HTML("<b style='margin-top: 20px;'>Evolution du nombre d'accident</b>")),
                                         amChartsOutput("accidents_nationalite"))),
                                       
                                       column(width = 6, wellPanel(
                                         h3(HTML("<b style='margin-top: 20px;'>Répartition des causes</b>")),
                                         amChartsOutput("radar_nationalite")))
                                     ) ##### Fin du fluidRow
                                  ) ##### Fin de column
                                ) ##### Fin du fluidRow
                              ) ##### Fin du tabPanel nationalité
                          

                        ), ##### Fin du tabsetPanel
                      ), ##### Fin du tabPanel pour la page Analyse #####
    

    
    ##########################
    ##### Page Recherche #####
    ##########################
    
    navbarMenu(title = "Rechercher",
               
               tabPanel(title = "Par nationalité",
                        h1(HTML("<b>Recherche par nationalité</b>")),
                        class = "justifier-texte",
                        p(HTML("Sur cette page, vous pouvez rechercher des informations sur une nationalité particulière. Utilisez la liste déroulante ci-dessous pour sélectionner une nationalité et obtenir le nombre total d'accidents impliquant des alpinistes de cette nationalité.")),
                        tags$hr(),
                        fluidRow(
                          # Colonne du wellPanel pour les options de recherche
                          column(width = 3, wellPanel(
                            selectInput(inputId = "nat_rech", label = "Sélectionner une nationalité à rechercher", choices = c("", unique(data$region))),
                            fluidRow(
                              # Placer les boutons dans la même colonne
                              column(width = 6, align = "left", actionButton("do2", "Rechercher", class = "btn-block")),
                              column(width = 6, align = "right", actionButton("res2", "Réinitialiser", class = "btn-block"))
                            ) ##### Fin du fluidRow
                          ) ##### Fin du wellPanel #####
                          ), ##### Fin du column pour les options de recherche #####
                          
                          # Colonne pour afficher les cartes
                          column(width = 9, 
                                 # Contenu de l'onglet "Par nationalité"
                                 tags$div(
                                   leafletOutput("carte_nationalite")
                                 ) ##### Fin du contenu de l'onglet "Par nom" #####
                          ) ##### Fin de la colonne pour afficher les cartes #####
                        ) ##### Fin du fluidRow #####
               ),##### Fin du tabPanel "Par nationalité" #####
               
               tabPanel(title = "Par individu",
                        h1(HTML("<b>Recherche par individu</b>")),
                          class = "justifier-texte",
                          p(HTML("Sur cette page, vous pouvez rechercher des informations sur un alpiniste spécifique. Utilisez la liste déroulante ci-dessous pour sélectionner un alpiniste et obtenir les détails suivants : son nom, la cause de l'accident, sa nationalité, la date de l'accident et la montagne concernée.")),
                          tags$hr(),
                        fluidRow(
                          # Colonne du wellPanel pour les options de recherche
                          column(width = 3, wellPanel(
                            selectInput(inputId = "text_rech", label = "Sélectionner un alpiniste à rechercher", choices = c("", unique(data$Name))),
                            fluidRow(
                              # Placer les boutons dans la même colonne
                              column(width = 6, align = "left", actionButton("do1", "Rechercher", class = "btn-block")),
                              column(width = 6, align = "right", actionButton("res1", "Réinitialiser", class = "btn-block"))
                            ) ##### Fin du fluidRow
                          ) ##### Fin du wellPanel #####
                          ), ##### Fin du column pour les options de recherche #####
                          
                          # Colonne pour afficher les cartes
                          column(width = 9, 
                                 # Contenu de l'onglet "Par nom"
                                 tags$div(
                                   leafletOutput("carte_nom")
                                 ) 
                          ) ##### Fin de la colonne pour afficher les cartes #####
                        ) ##### Fin du fluidRow #####
               )##### Fin du tabPanel #####
               
    ),
    
    
    
    #########################
    ##### Page Database #####
    #########################
    
    navbarMenu(title = "Database",
               tabPanel("Database Accidents",
                        # Titre de la page
                        h1(HTML("<b>Présentation de la base de données sur les accidents</b>")),
                        
                        # Texte présentant la base de données
                        tags$div(
                          class = "justifier-texte",
                          p("Cet ensemble de données contient des informations sur les grimpeurs qui ont tragiquement perdu la vie en essayant d'atteindre le sommet des huit mille eurs emblématiques. Les huit mille sont les 14 sommets qui atteignent ou dépassent une altitude de 8 000 mètres au-dessus du niveau de la mer. On va retrouver les variables suivantes :"),
                          tags$ul(
                            class = "justifier-texte",
                            tags$li(HTML("<b>Date</b> : la date de l'accident, fournissant un repère temporel pour chaque événement tragique.")),
                            tags$li(HTML("<b>Name</b> : le nom de l'alpiniste décédé, rappelant l'identité et le courage de ceux qui se sont aventurés dans ces environnements impitoyables.")),
                            tags$li(HTML("<b>Nationalité</b> : la nationalité de l'alpiniste décédé, mettant en évidence la diversité des individus attirés par le défi de gravir les plus hauts sommets du monde.")),
                            tags$li(HTML("<b>Cause of death</b> : la cause de la mort, révélant les dangers inhérents à ces expéditions et les risques mortels auxquels sont confrontés les alpinistes.")),
                            tags$li(HTML("<b>Mountain</b> : la montagne sur laquelle il est décédé, symbolisant les sommets imposants et les défis redoutables qu'ils représentent pour les aventuriers intrépides."))
                          ),
                          p("Chacune de ces variables contribue à notre compréhension des événements tragiques survenus lors de ces ascensions périlleuses, nous invitant à réfléchir sur la nature de l'alpinisme extrême et les sacrifices qu'il exige.")
                        ),
                        
                        # Ajout d'une séparation entre le texte et l'affichage de la base de données
                        tags$hr(),
                        
                        # Affichage de la base de données
                        dataTableOutput("db_accidents")
               ), ##### Fin du tabPanel
               
               
               tabPanel("Database Montagnes",
                        # Titre de la page
                        h1(HTML("<b>Présentation de la base de données sur les montagnes</b>")),
                        
                        tags$div(
                          class = "justifier-texte",
                          p("Cet ensemble de données contient des informations sur les montagnes emblématiques atteignant ou dépassant une altitude de 8 000 mètres au-dessus du niveau de la mer, connues sous le nom de 'huit mille'. Chaque montagne est une majesté naturelle, mais aussi un défi redoutable pour les alpinistes qui osent les escalader."),
                          tags$ul(
                            class = "justifier-texte",
                            tags$li(HTML("<b>Mountain name(s)</b> : le nom de la montagne, une icône parmi les sommets les plus élevés de la planète.")),
                            tags$li(HTML("<b>Height_m</b> : l'altitude de la montagne en mètres, déterminante pour sa classification parmi les 'huit mille'.")),
                            tags$li(HTML("<b>coordinates</b> : les coordonnées géographiques de la montagne, permettant de la localiser avec précision sur la carte.")),
                            tags$li(HTML("<b>Parent Mountain</b> : la montagne parente, si la montagne fait partie d'une chaîne de montagnes.")),
                            tags$li(HTML("<b>country</b> : le pays où se situe la montagne, offrant des défis uniques et des perspectives différentes aux alpinistes."))
                          ),
                          p(HTML("Chacune de ces variables nous permet de mieux comprendre ces géants naturels et les défis qu'ils présentent aux alpinistes du monde entier. Pour compléter les informations de ce jeu de données, nous avons créé un data frame contenant un lien vers une image de lamontagne ainsi qu'une description de celle-ci."))
                        ),
                        
                        # Ajout d'une séparation entre le texte et l'affichage de la base de données
                        tags$hr(),
                        
                        # Affichage de la base de données
                        dataTableOutput("db_montagnes")),
               
               tabPanel("Database Finale", 
                        h1(HTML("<b>Présentation de la base de données finale</b>")),
                        
                        tags$div(
                          class = "justifier-texte",
                          p("Cette base de données finale est le résultat de la fusion des deux bases de données précédentes. Elle contient des informations essentielles sur les accidents d'alpinisme ainsi que sur les montagnes emblématiques de plus de 8000 mètres. Cette fusion nous permet d'analyser les incidents tragiques survenus lors des tentatives d'ascension de ces sommets impressionnants. Les variables utilisées dans nos analyses ont été présentées dans les bases de données précédentes. Quelques variables calculées ont été ajoutées telles que la saison, les coordonnées en latitude et longitude."),
                          p(HTML("Chacune de ces variables contribue à notre compréhension des événements tragiques survenus lors de ces ascensions périlleuses, nous invitant à réfléchir sur la nature de l'alpinisme extrême et les sacrifices qu'il exige."))
                        ),
                        
                        # Ajout d'une séparation entre le texte et l'affichage de la base de données
                        tags$hr(),
                        
                        # Affichage de la base de données
                        dataTableOutput("db_finale"))
    ), ##### Fin du navBarMenu ######
    
    #########################
    ##### Page À propos #####
    #########################
    
    tabPanel(title = "À propos",
             fluidPage(
               # Contenu de la page À propos
               h1(HTML("<b>À propos de cette application</b>")),
               p("L'application Les 8000m est un projet de visualisation réalisé dans le cadre du Master 1 en Mathématiques Appliquées et Statistique (MAS). Elle a été conçue pour explorer et analyser les accidents d'alpinisme survenus sur les sommets de plus de 8000 mètres d'altitude."),
               p("Elle fournit des informations détaillées sur les accidents, les montagnes, et permet aux utilisateurs d'effectuer des recherches et d'analyser les données."),
               p("Nous espérons que cette application vous sera utile et informative."),
               h3("Source des données"),
               tags$ul(
                 tags$li("Kaggle - Mountain Climbing Accidents Dataset - ", tags$a(href = "https://www.kaggle.com/datasets/asaniczka/mountain-climbing-accidents-dataset", "https://www.kaggle.com/datasets/asaniczka/mountain-climbing-accidents-dataset")),
                 tags$li("Kaggle - Mountains dataset with coordinates and countries - ", tags$a(href = "https://www.kaggle.com/datasets/keagle/mountains-dataset-with-coordinates-and-countries?select=Top+montains+data.csv", "https://www.kaggle.com/datasets/keagle/mountains-dataset-with-coordinates-and-countries?select=Top+montains+data.csv"))
               ),
               p("Développé par BIHEL Léo, MARSAC Gabin, FRANCOIS Gautier"),
               p("Version 1.4.1")
             ) ##### Fin du fluidPage #####
    )##### Fin du tabPanel #####
  ) ##### Fin du navBarPage #####
)