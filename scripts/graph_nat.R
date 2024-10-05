# Selection des individus
data_nationalite <- data_nationalite |>
  filter(Nombre >= 20)


# Graphique nationalité
nationalite <- plot_ly(data_nationalite, x = ~Nombre, y = ~reorder(region, Nombre), type = 'bar', 
        marker = list(color = 'rgb(197, 224, 180)', line = list(color = 'black', width = 1))) %>%
  
  # Mise en forme du layout
  layout(title = list(text = 'Nombre de morts par nationalité', 
                      font = list(size = 20), 
                      y = 1),
         yaxis = list(tickangle = 0, 
                      showline = TRUE, 
                      showgrid = FALSE,
                      titlefont = list(size = 20),
                      tickfont = list(size = 15)),
         xaxis = list(title = 'Nombre', 
                      showline = TRUE,
                      showgrid = TRUE,
                      titlefont = list(size = 20),
                      tickfont = list(size = 15)),
         showlegend = FALSE)