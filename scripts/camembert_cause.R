library(plotly)

# Diagramme camembert
camembert_cause <- plot_ly(data_cause, labels = ~Cause_death, values = ~Nombre, type = "pie",
        textposition = 'inside',
        textinfo = 'label+percent',
        insidetextfont = list(color = '#FFFFFF'),
        hoverinfo = 'text',
        text = ~paste('Nombre de victimes : ', Nombre, 'morts'))