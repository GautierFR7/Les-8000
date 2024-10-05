##### Librairies #####
library(igraph)

##### Fonnction #####
reseau_montagne <- function(data){
  
  data_reseau <- data |> select(Parent_mountain, Mountain) |> unique() |> na.omit()
  
  # Créer un graphe dirigé à partir du data frame
  graph <- graph_from_data_frame(data_reseau, directed = TRUE)
  
  # Plotter le graphe
  
  arbre_parent <- plot(
    graph,
    layout = layout.reingold.tilford,
    main = "Lien de parenté entre les montagnes",
    vertex.label.family = "Arial",
    vertex.color = "grey",
    vertex.frame.color = "white",
    vertex.label.color = "black",
    vertex.shape = "circle",
    vertex.size = 10,
    vertex.label.cex = 1,
    edge.color = "black",
    edge.label.color = "black",
    edge.width = 1,
    edge.arrow.width = 1,
    edge.arrow.size = 0.5,
    asp = 0.35,
    margin = 0)
  
  return(arbre_parent)
}

