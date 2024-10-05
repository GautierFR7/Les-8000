# Charger les packages nécessaires
library(leaflet)
library(dplyr)
library(sf)
#library(rnaturalearth)


# Fonction 
carte_accident_nationalite <- function(data){
  
  # Afficher la carte Leaflet avec des polygones colorés en fonction du nombre d'accidents
  mybins <- c(0, 1, 10 ,20, 50, 100, Inf)
  mypalette <- colorBin(palette = "YlOrBr", na.color = "transparent", bins=mybins)
  
  leaflet(data = data) %>%
    addTiles() %>%
    setView(lng = 0, lat = 40, zoom = 2) %>%
    addPolygons(
      fillColor = ~mypalette(Nombre),
      fillOpacity = 0.7,
      color = "black",
      weight = 1,
      highlight = highlightOptions(
        bringToFront = TRUE,
        color = "black",
        weight = 3),
      label = ~paste0(region, " : ", Nombre, " accidents"),
      labelOptions = labelOptions(
        style = list("background-color" = "white", "padding" = "8px", "border-radius" = "5px"),
        textsize = "15px",
        direction = "auto"
      )
    ) %>%
    addLegend( pal=mypalette, values=~Nombre, opacity=0.9, title = "Nb accidents", position = "bottomleft" )
}

