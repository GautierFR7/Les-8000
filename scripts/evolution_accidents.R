library(plotly)

# Data frame
annee_max_morts <- data_annee %>%
  group_by(Year) %>%
  summarise(Sum_morts = sum(Nombre, na.rm = TRUE)) %>%
  top_n(1, wt = Sum_morts) %>%
  pull(Year)

# Créer une colonne pour indiquer si l'année est celle avec le plus de morts
data_annee$MaxMorts <- ifelse(data_annee$Year == annee_max_morts, "MaxMorts", "Autres")

# Création du graphique
evolution_accidents <- plot_ly(data_annee, x = ~Year, y = ~Nombre, type = "bar", 
        color = ~ifelse(Year == annee_max_morts, "red", "grey"), 
        colors = c("grey", "red"),
        marker = list(line = list(color = 'black', width = 1)),
        hoverinfo = "y+text", 
        text = ~paste("Année: ", Year, "<br>Nombre de morts: ", Nombre)) %>%
  layout(title = "Nombre de morts par année",
         xaxis = list(title = "Année"),
         yaxis = list(title = "Nombre de morts"))


