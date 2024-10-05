##### librairies #####
library(rAmCharts)

##### Fonction #####
barplot_nationalite <- function(data){
  
  # Mise en forme du data frame
  data <- data |>
    group_by(region) |>
    summarise(Nombre = n()) |>
    top_n(5, Nombre) |>
    arrange(by = desc(Nombre))
  
  
  barplot_nationalite <- amBarplot(x = "region", y = "Nombre", data = data, horiz = TRUE)
  
  return(barplot_nationalite)
}