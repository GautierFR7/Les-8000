##### Librairies #####
library(rAmCharts)

##### Fonction #####
pie_plot_cause <- function(data){
  
  # Mise en forme du data frame
  data <- data |> 
    group_by(label = Cause_death) |> 
    summarise(value = n()) |>
    arrange(by = value)
  
  # Graphique
  pie <- amPie(data = data)
  
  return(pie)
}