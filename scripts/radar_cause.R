##### Librairies #####
library(Amelia)

##### Fonction #####
radar <- function(data){
  
  # Mise en forme du data frame
  data <- data |> 
    group_by(label = Cause_death) |> 
    summarise(Nombre = n())
  
  # Graphique
  radar <- amRadar(data = data)
  return(radar)
}
