library(leaflet)

# Générer une carte du monde vide
carte_nationalite_vide <- leaflet(data = data_total) |>
  addTiles() %>%
  setView(lng = 0, lat = 0, zoom = 1)

# Générer une carte remplie en fonction de la nationalité recherchée
carte_nationalite_pleine <- function(data_total){
  
  # Grouper par montagne et compter le nombre d'accidents
  group <- data_total %>%
    select(Mountain, latitude, longitude) %>%
    group_by(Mountain) %>%
    mutate(Nombre = n())
  
  # Générer la carte
  carte_nat <- leaflet(data = group) |>
    addTiles() |>
    setView(lng = mean(group$longitude), lat = mean(group$latitude), zoom = 5) |>
    addMarkers(
      lng = ~longitude, lat = ~latitude,
      popup = ~paste(
        "Nombre d'accidents sur la montagne", Mountain, ":", Nombre
      ),
      label = ~as.character(Mountain)
    )
  # Retourner la carte
  return(carte_nat)
}