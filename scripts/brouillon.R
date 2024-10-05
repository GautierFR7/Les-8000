tabPanel(title = "Les accidents",
         fluidRow(
           
           # Colonne 1
           column(width = 3, wellPanel(
             selectInput(inputId = "choix_montagne", label = "Sélectionner une montagne", choices = c("", unique(data_total$Mountain))),
             selectInput(inputId = "choix_nat", label = "Sélectionner une nationalité", choices = c("", unique(data_total$region))),
             selectInput(inputId = "choix_cause", label = "Sélectionner une cause", choices = c("", unique(data_total$Cause_death))),
             dateRangeInput(inputId = "choix_date", label = "Sélectionner une période")
           )),
           
           # Colonne 2
           column(width = 9,
                  fluidRow(
                    infoBox(
                      "Accidents", uiOutput("kpi1_value"), "accidents sur les +8000m",
                      icon = icon("heart"), color = "blue"
                    ),
                    infoBox(
                      "Nationalité", uiOutput("kpi2_value"), "la plus représentée",
                      icon = icon("flag"), color = "blue"
                    ),
                    infoBox(
                      "Cause", uiOutput("kpi3_value"), "est la principale cause d'accident",
                      icon = icon("line-chart"), color = "blue"
                    )
                  ),
                  
                  
                  # Ligne pour graphique en bar du nombre d'accidents
                  amChartsOutput("accidents"),
                  fluidRow(
                    
                    # Colonne pour graphique en bar nationalité
                    column(width = 6, amChartsOutput("nat")),
                    
                    # Colonne pour diagramme en camembert cause de l'accident
                    column(width = 6, amChartsOutput("camembert"))
                  )),
         )),