#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

##############################################
##### Importation des différents scripts #####
##############################################

# Scripts page Montagnes
source("scripts/carte_8000.R")
source("scripts/reseau_montagnes.R")
source("scripts/correspondance_desc_img.R")

# Scripts page Accidents
source("scripts/barplot_accidents.R")
source("scripts/radar_cause.R")
source("scripts/barplot_nationalite.R")
source("scripts/carte_accident_nationalite.R")

# Scripts page Recherche
source("scripts/carte_recherche_alpiniste.R")
source("scripts/carte_recherche_nationalite.R")

##################
##### Server #####
##################

# Define server logic required to draw a histogram
function(input, output, session) {
  
  #########################
  ##### Page Montagne #####
  #########################
  
  # Carte leaflet des +8000m
  output$carte_8000 <- renderLeaflet({
    carte_8000(data_monts_8000)
  })
  
  # Reseau montagnes
  output$reseau <- renderPlot({
    reseau_montagne(data_total)
  })

  # Image et description de la montagne
  observeEvent(input$carte_8000_marker_click, { 
    event <- input$carte_8000_marker_click
    
    # Vérifier si event$id est défini
    if (!is.null(event) && !is.null(event$id)) {
      montagne <- correspondance_desc_img[correspondance_desc_img$Nom_montagne == event$id, "Nom_montagne"]
      description <- correspondance_desc_img[correspondance_desc_img$Nom_montagne == event$id, "Description"]
      image <- correspondance_desc_img[correspondance_desc_img$Nom_montagne == event$id, "Nom_image"]
      
      # Afficher le nom de la montagne
      output$nom_montagne <- renderText(montagne)
      
      # Afficher la description
      output$description_montagne <- renderText(description)
      
      # Afficher l'image
      output$image_montagne <- renderImage({
        list(src = paste0("www/", image), width = "500px", height = "auto")
      }, deleteFile = FALSE)
      
      output$wellPanel <- renderUI({
        fluidRow(
          class = "centered espace-entre-texte-et-image",
          column(width = 6, wellPanel(imageOutput("image_montagne"), style = "padding: 10px; margin: 10px; margin-top: 10px;")),
          column(width = 6, wellPanel(h4(strong(textOutput("nom_montagne"))), textOutput("description_montagne"), style = "text-align: justify; margin-top: 10px;"))
        )
      })
    } 
    else { # Si aucun événement n'est sélectionné :
      # Affiche un message par défaut 
      output$description_montagne <- renderText("Sélectionnez une montagne pour afficher les détails.")
      
      # Affiche une image vide
      output$image_montagne <- renderImage({
        list(src = "", width = 300, height = 200)
      }, deleteFile = FALSE)
    }
  })
  
  
  ##########################
  ##### Page Accidents #####
  ##########################
  
  ##### Partie nationalité #####
  
  # Afficher les graphiques  de manière global quand on arrive sur la page
  
  # Barplot Evolution des accidents
  output$accidents_nationalite <- renderAmCharts({
    barplot_accidents_annee(data_total)
    })
  
  # Radar des causes d'accidents
  output$radar_nationalite <- renderAmCharts({
    radar(data_total)
    })
  
  # Carte des accidents par nationalité
  output$carte_accident_nationalite <- renderLeaflet({
    carte_accident_nationalite(data_accident_nat)
  })
  
  # Afficher le nombre de morts
  output$nombre_morts_nat <- renderText({nrow(data_total)})
  
  # Afficher la cause
  output$cause_repr_nat <- renderText({
    causes_table <- table(data_total$Cause)
    max_freq <- max(causes_table)
    most_common_causes <- names(causes_table[causes_table == max_freq])
    paste(most_common_causes, collapse = ", ")
  })

  
  # Ajuster les graphiques en fonction de la nationalité sélectionnée
  observeEvent(input$do_accident_nat, {
    if(input$choix_nat == "") {
      output$accidents_nationalite <- renderAmCharts({barplot_accidents_annee(data_total)})
      output$radar_nationalite <- renderAmCharts({radar(data_total)})
      
      output$nombre_morts_nat <- renderText({nrow(data_total)})
      output$cause_repr_nat <- renderText({
        causes_table <- table(data_total$Cause)
        max_freq <- max(causes_table)
        most_common_causes <- names(causes_table[causes_table == max_freq])
        paste(most_common_causes, collapse = ", ")
      })
    }
    else{
      data_total <- data_total[data_total$region == input$choix_nat,]
      
      output$accidents_nationalite <- renderAmCharts({barplot_accidents_annee(data_total)})
      output$radar_nationalite <- renderAmCharts({radar(data_total)})
      
      output$nombre_morts_nat <- renderText({nrow(data_total)})
      output$cause_repr_nat <- renderText({
        causes_table <- table(data_total$Cause)
        max_freq <- max(causes_table)
        most_common_causes <- names(causes_table[causes_table == max_freq])
        paste(most_common_causes, collapse = ", ")
      })
    }
  })
  
  # Réinitialiser la narionalité et les graphiques
  observeEvent(input$res_accident_nat, {
    updateSelectInput(session, "choix_nat", selected = "")
    
    output$accidents_nationalite <- renderAmCharts({barplot_accidents_annee(data_total)})
    output$radar_nationalite <- renderAmCharts({radar(data_total)})
    output$carte_accident_nationalite <- renderLeaflet({carte_accident_nationalite(data_accident_nat)})
    
    output$nombre_morts_nat <- renderText({nrow(data_total)})
    output$cause_repr_nat <- renderText({
      causes_table <- table(data_total$Cause)
      max_freq <- max(causes_table)
      most_common_causes <- names(causes_table[causes_table == max_freq])
      paste(most_common_causes, collapse = ", ")
    })
  })
  
  
  ##### Partie montagne
  
  # Afficher les graphiques  de manière global quand on arrive sur la page
  
  # Barplot Evolution des accidents
  output$accidents_montagne <- renderAmCharts({
    barplot_accidents_annee(data_total)
  })
  
  # Barplot Nationalités les plus représentées
  output$barplot_nat <- renderAmCharts({
    barplot_nationalite(data_total)
  })
  
  # Radar des causes d'accidents
  output$radar_montagne <- renderAmCharts({
    radar(data_total)
  })
  
  # Afficher le nombre de morts
  output$nombre_morts_montagne <- renderText({nrow(data_total)})
  
  # Afficher la cause
  output$cause_repr_montagne <- renderText({
    causes_table <- table(data_total$Cause)
    max_freq <- max(causes_table)
    most_common_causes <- names(causes_table[causes_table == max_freq])
    paste(most_common_causes, collapse = ", ")
  })
  
  # Ajuster les graphiques en fonction de la montagne sélectionnée
  observeEvent(input$do_accident_montagne, {
    if(input$choix_montagne == "") {
      output$accidents_montagne <- renderAmCharts({barplot_accidents_annee(data_total)})
      output$barplot_nat <- renderAmCharts({barplot_nationalite(data_total)})
      output$radar_montagne <- renderAmCharts({radar(data_total)})
      
      output$nombre_morts_montagne <- renderText({nrow(data_total)})
      output$cause_repr_montagne <- renderText({
        causes_table <- table(data_total$Cause)
        max_freq <- max(causes_table)
        most_common_causes <- names(causes_table[causes_table == max_freq])
        paste(most_common_causes, collapse = ", ")
      })
    }
    else{
      data_total <- data_total[data_total$Mountain == input$choix_montagne,]
      
      output$accidents_montagne <- renderAmCharts({barplot_accidents_annee(data_total)})
      output$barplot_nat <- renderAmCharts({barplot_nationalite(data_total)})
      output$radar_montagne <- renderAmCharts({radar(data_total)})
      
      output$nombre_morts_montagne <- renderText({nrow(data_total)})
      output$cause_repr_montagne <- renderText({
        causes_table <- table(data_total$Cause)
        max_freq <- max(causes_table)
        most_common_causes <- names(causes_table[causes_table == max_freq])
        paste(most_common_causes, collapse = ", ")
      })
    }
  })
  
  # Réinitialiser la narionalité et les graphiques
  observeEvent(input$res_accident_montagne, {
    updateSelectInput(session, "choix_montagne", selected = "")
    
    output$accidents_montagne <- renderAmCharts({barplot_accidents_annee(data_total)})
    output$barplot_nat <- renderAmCharts({barplot_nationalite(data_total)})
    output$radar_montagne <- renderAmCharts({radar(data_total)})
    
    output$nombre_morts_montagne <- renderText({nrow(data_total)})
    output$cause_repr_montagne <- renderText({
      causes_table <- table(data_total$Cause)
      max_freq <- max(causes_table)
      most_common_causes <- names(causes_table[causes_table == max_freq])
      paste(most_common_causes, collapse = ", ")
    })
  })
  
  
  ##########################
  ##### Page Recherche #####
  ##########################
  
  # Afficher une carte vide quand on arrive sur la page
  output$carte_nom <- renderLeaflet({
    carte_nom_vide
  })
  
  # Mettre à jour la carte en fonction de la recherche
  observeEvent(input$do1, {
    
    # Si pas d'alpiniste recherché, alors affiche une carte vide
    if(input$text_rech == "") {output$carte_nom <- renderLeaflet({carte_nom_vide})}
    
    else if(!input$text_rech %in% data_total$Name) {output$carte_nom <- renderLeaflet({carte_nom_vide})}
    
    # Affiche la localisation de l'alpiniste recherché
    else{
      # Mettre à jour le data frame en fonction de la recherche
      data_total <- data_total[data_total$Name == input$text_rech,]
      
      # Afficher la carte avec la localisation de l'alpiniste recherché
      output$carte_nom <- renderLeaflet({carte_nom_pleine(data_total)})
    }
  }
  )
  
  
  # Afficher une carte vide quand on arrive sur la page
  output$carte_nationalite <- renderLeaflet({
    carte_nationalite_vide
  })
  
  observeEvent(input$do2, {
    
    # Si pas de nationalité recherchée, alors affiche une carte vide
    if(input$nat_rech == "") {output$carte_nationalite <- renderLeaflet({carte_nationalite_vide})}
    
    else{
      # Mettre à jour le data frame en fonction de la recherche
      data_total <- data_total[data_total$region == input$nat_rech,]
      
      # Afficher la carte avec les différentes montagnes ou ont eu lieu des accidents pour cette nationalité
      output$carte_nationalite <- renderLeaflet({carte_nationalite_pleine(data_total)})
    }
  }
  )
  
  # Réinitialiser la recherche pour nom 
  observeEvent(input$res1, {
    updateSelectInput(session, "text_rech", selected = "")
    
    output$carte_nom <- renderLeaflet({carte_nom_vide})
  })
  
  # Réinitialiser la recherche pour nationalié
  observeEvent(input$res2, {
    updateSelectInput(session, "nat_rech", selected = "")
    
    output$carte_nationalite <- renderLeaflet({carte_nationalite_vide})
  }) 
  
  
  #########################
  ##### Page Database #####
  #########################
  
  output$db_finale <- renderDataTable({data_total},
                                      options = list(
                                        scrollY = "300px",  # Hauteur maximale du tableau
                                        scrollX = TRUE))# Activer la barre de défilement horizontale)
  
  output$db_accidents <- renderDataTable({data_accidents_brut},
                                         options = list(
                                           scrollY = "300px",  # Hauteur maximale du tableau
                                           scrollX = TRUE)) # Activer la barre de défilement horizontale
  
  output$db_montagnes <- renderDataTable({data_montagnes_brut},
                                         options = list(
                                           scrollY = "300px",  # Hauteur maximale du tableau
                                           scrollX = TRUE)) # Activer la barre de défilement horizontale
  
}













