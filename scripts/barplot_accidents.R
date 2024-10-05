##### Librairies #####
library(rAmCharts)

##### Fonction #####
barplot_accidents_annee <- function(data){
  
  # Mise en forme du df pour créer le graphique
  data <- data |>
    group_by(Year = lubridate::year(as.Date(Date))) |>
    summarise(Nombre = n()) |>
    complete(Year = seq(1895, 2023, 1), fill = list(Nombre = 0))
  
  # Convertir les colonnes en character
  data$Year <- as.character(data$Year)
  
  # Barplot
  barplot_accidents_annee <- amBarplot(data = data, x = "Year", y = "Nombre", labelRotation = -45)
  
  return(barplot_accidents_annee)
}


