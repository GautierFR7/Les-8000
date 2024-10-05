library(rAmCharts)
library(ggplot2)
library(plotly)
library(hrbrthemes)
library(dplyr)

barplot_saison <- function(data){
  
  data <- data |> 
    group_by(Saison) |>
    summarise(Nombre = n())

  barplot_saison <- amBarplot(x = "Saison", y = "Nombre", data = data)
  
  return(barplot_saison)
}

barplot_saison(data_total)

# on peut voir que la majorité des accidents se sont déroulés au printemps. Ce qui est normal car la majorité des expéditions se font durant une période de temps
# très courte : le printemps, car c'est la saison ou les conditions météorologiques sont les plus "clémantes". On peut réaliser un test pour déterminer s'il y a 
# un lien entre la saison et la cause de l'accident.

# Supposons que votre dataframe est data_total

#################################
##### Cause_death et saison #####
#################################

data_test_saison_cause <- data_total |> select(Saison, Cause_death)
data_test_saison_cause$Saison <- as.factor(data_test_saison_cause$Saison)
data_test_saison_cause$Cause_death <- as.factor(data_test_saison_cause$Cause_death)

# Tableau de contingence
table_contingence_saison_cause <- table(data_test_saison_cause$Saison, data_test_saison_cause$Cause_death)
table_contingence_saison_cause

# Test du chi-carré
chi2_saison_cause <- chisq.test(table_contingence_saison_cause)
print(chi2_saison_cause)

# Les résultats du test du chi-carré indiquent une statistique de test (X-squared) de 170.15 avec 21 degrés de liberté et une valeur p très faible (< 2.2e-16).
# Cela suggère que vous avez des preuves significatives pour rejeter l'hypothèse nulle d'indépendance entre la saison et la cause de l'accident.
# En d'autres termes, il semble y avoir un lien statistiquement significatif entre la saison et la cause de l'accident dans vos données.

# Il est important de noter que le test du chi-carré détecte une association statistique mais ne permet pas d'établir une relation de causalité.
# Pour une compréhension plus approfondie de la nature de cette association, d'autres analyses et considérations peuvent être nécessaires.

###################################
##### Cause_death et Mountain #####
###################################

data_test_montagne_cause <- data_total |> select(Cause_death, Mountain)
data_test_montagne_cause$Cause_death <- as.factor(data_test_montagne_cause$Cause_death)
data_test_montagne_cause$Mountain <- as.factor(data_test_montagne_cause$Mountain)

# Tableau de contingence
table_contingence_montagne_cause <- table(data_test_montagne_cause$Cause, data_test_montagne_cause$Mountain)
table_contingence_montagne_cause

# Test du chi-carré
chi2_montagne_cause <- chisq.test(table_contingence_montagne_cause)
print(chi2_montagne_cause)

# Étant donné que la valeur p est bien en dessous du seuil de signification de 0.05 (ou même bien en dessous de 0.01), 
# on rejette l'hypothèse nulle selon laquelle les variables Montagne et Cause sont indépendantes. 
# Cela signifie qu'il existe une association significative entre les deux variables.


# Charger la bibliothèque pour la régression logistique multinomiale
library(nnet)

data_classification <- data_total |> select(Cause_death, Month, Mountain, region, Year, Saison)
data_classification$Cause_death <- as.factor(data_classification$Cause_death)
data_classification$Month <- as.factor(data_classification$Month)
data_classification$Mountain <- as.factor(data_classification$Mountain)
data_classification$region <- as.factor(data_classification$region)
data_classification$Year <- as.factor(data_classification$Year)
data_classification$Saison <- as.factor(data_classification$Saison)


# Définir une graine aléatoire pour la reproductibilité
set.seed(123)

# Séparer les données en ensembles d'entraînement et de test (par exemple, 80% pour l'entraînement, 20% pour le test)
train_indices <- sample(1:nrow(data_classification), 0.8 * nrow(data_classification))
train_data <- data_classification[train_indices, ]
test_data <- data_classification[-train_indices, ]

# Ajuster le modèle de régression logistique multinomiale sur l'ensemble d'entraînement
model <- multinom(Cause_death ~ Saison + Mountain, data = train_data)

# Faire des prédictions sur l'ensemble de test
predictions <- predict(model, newdata = test_data, type = "class")

# Évaluer les performances du modèle (par exemple, taux de classification)
accuracy <- mean(predictions == test_data$Cause_death)
print(paste("Taux de classification sur l'ensemble de test :", accuracy))

# Créer un nouveau dataframe pour les prédictions spécifiques
new_data <- data.frame(Saison = factor("Printemps", levels = levels(train_data$Saison)),
                       Mountain = factor("Mount Everest", levels = levels(train_data$Mountain)))

# Faire des prédictions sur les nouvelles données
predictions <- predict(model, newdata = new_data, type = "class")

# Afficher les prédictions
print(predictions)


####################
##### Heat map #####
####################

data_test_saison_cause <- data_test_saison_cause %>%
  group_by(Saison, Cause_death) %>%
  summarise(Nombre = n())
  
total_accidents_par_saison <- data_test %>%
  group_by(Saison) %>%
  summarise(TotalAccidents = sum(Nombre))

data_test <- left_join(data_test, total_accidents_par_saison, by = "Saison")

data_test <- data_test %>%
  mutate(Nombre_norm = Nombre / TotalAccidents) %>%
  select(Saison, Cause_death, Nombre_norm)

# Créer le heatmap avec les données normalisées
plot_ly(
  x = data_test$Saison,
  y = data_test$Cause_death,
  z = data_test$Nombre_norm,
  type = "heatmap",
  colors = colorRamp(c("yellow", "red"))
)

# Ainsi grâce à cette heatmap, on peut observer certaines tendance :
# - durant l'automne la cause principale d'accident est les avalanche avec près de 70% des accidents,
# - en été, 60% des accidents sont dû à une chute ou des avalanches
# - en hiver, c'est à peut près le même schéma qu'en été, avec un leger accent sur les chutes
# - finallement, le printemps partage 3 causes principales qui représentent 75% des accidents : maladie, chute et avalanche
# On peut observer que la cause majoritaire est les avalanches. Bien que mortelle dans le plupart des cas, les tempêtes représentent une infime partie des accidents.
# surement dû au fait qu'avant de se lancer dans une expédition (ex : aller du camp 3 au camp4), les alpinistes ont étudié attentivement les conditions climatiques.
# De même pour la maladie et la fatigue ou les alpinistes s'assurent d'avoir la condition physique nécessaire pour pouvoir continuer l'ascention.
