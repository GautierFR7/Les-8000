##### Librairies #####
library(leaflet)

##### Fonction #####
carte_8000 <- function(data_monts_8000){
  
  # Carte
  carte_8000 <- leaflet(data = data_monts_8000) %>%
    addTiles() %>%
    setView(lng = mean(data_monts_8000$longitude), lat = mean(data_monts_8000$latitude), zoom = 5) %>%
    #Ajout des marqueurs
    addMarkers(lng = ~longitude, lat = ~latitude,
               popup = ~paste("<b>", Mountain, "</b>", ":",
                              "<br> - <b> Pays : </b>", country,
                              "<br> - <b> Hauteur : </b>", Height_m,"m",
                              "<br> - <b> 1ère Ascension : </b>", ascents_first),
               label = ~as.character(Mountain),
               layerId = ~Mountain)%>%
    
    # Ajouter les tuiles topographiques 
    addProviderTiles("Esri.WorldTopoMap", group = "Vue Topologique") %>%
    # Ajouter les tuiles d'imagerie satellite
    addProviderTiles("Esri.WorldImagery", group = "Vue Satellite") %>%
    # Ajouter un contrôle de couches pour basculer entre les deux groupes de tuiles
    addLayersControl(
      baseGroups = c("Vue Topologique", "Vue Satellite"),
      options = layersControlOptions(collapsed = FALSE)
    )
  
  return(carte_8000)
}


