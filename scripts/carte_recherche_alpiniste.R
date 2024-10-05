library(leaflet)

# Générer une carte du monde vide
carte_nom_vide <- leaflet(data = data_total) %>%
  addTiles() %>%
  setView(lng = 0, lat = 0, zoom = 1)

# Générer une carte remplie en fonction de l'alpiniste recherché
carte_nom_pleine <- function(data_total){
    carte_nom <- leaflet(data = data_total) %>%
      addTiles() %>%
      setView(lng = mean(data_total$longitude), lat = mean(data_total$latitude), zoom = 5) %>%
      addMarkers(
        lng = ~longitude, lat = ~latitude,
        popup = ~paste(
          "<b>", Name, "</b>", ":",
          "<br> - <b> Date </b> :", Date,
          "<br> - <b> Cause </b> :", Cause_death,
          "<br> - <b> Nationalité </b> :", region
        ),
        label = ~as.character(Mountain)
      )
    return(carte_nom)
}

