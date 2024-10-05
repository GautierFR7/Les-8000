library(leaflet)

# Générer une carte du monde vide
carte_nom_vide <- leaflet(data = data_total) %>%
  addTiles() %>%
  
  # Ajouter les tuiles topographiques 
  addProviderTiles("Esri.WorldTopoMap", group = "Vue Topologique") %>%
  # Ajouter les tuiles d'imagerie satellite
  addProviderTiles("Esri.WorldImagery", group = "Vue Satellite") %>%
  # Ajouter un contrôle de couches pour basculer entre les deux groupes de tuiles
  addLayersControl(
    baseGroups = c("Vue Topologique", "Vue Satellite"),
    options = layersControlOptions(collapsed = FALSE)
  )

# Générer une carte remplie en fonction de l'alpiniste recherché
carte_nom_pleine <- function(data_total){
    carte_nom <- leaflet(data = data_total) %>%
      addTiles() %>%
      setView(lng = mean(data_total$longitude), lat = mean(data_total$latitude), zoom = 5) %>%
      addMarkers(
        lng = ~longitude, lat = ~latitude,
        popup = ~paste(
          Name, ":",
          "<br> - Date :", Date,
          "<br> - Cause :", Cause_death,
          "<br> - Nationalité :", region
        ),
        label = ~as.character(Mountain)
      )
    
    return(carte_nom)
}

