# Supposons que votre data frame s'appelle df
# Remplacez "df" par le nom réel de votre data frame

# Installer et charger le package nécessaire
install.packages("nnet")
library(nnet)

data_classification$Month <- as.factor(data_classification$Month)
data_classification$region <- as.factor(data_classification$region)
data_classification$Mountain <- as.factor(data_classification$Mountain)
data_classification$Cause_death <- as.factor(data_classification$Cause_death)

# Créer un modèle de régression logistique
model <- multinom(Cause_death ~ Month + region + Mountain, data = data_classification)

# Afficher un résumé du modèle
summary(model)

# Utiliser le modèle pour faire des prévisions sur de nouvelles données
# Supposons que vous avez une nouvelle ligne de données appelée new_data
# Remplacez "new_data" par les valeurs réelles de votre nouvelle observation
new_data <- data.frame(Month = as.factor(07), region = "Austria", Mountain = "Makalu")

# Faire des prévisions
predictions_nnet <- predict(model, newdata = new_data, type = "probs")

# Afficher les probabilités prédites pour chaque classe
print(predictions_nnet)
































# Install and load the required package
install.packages(c("naivebayes", "caTools"))
library(naivebayes)
library(caTools)

# Suppose df is your dataframe
# Replace 'your_dataset.csv' with the actual file name or use your dataframe directly
# df <- read.csv('your_dataset.csv')
df <- data_total[c("Month", "region", "Mountain", "Cause_death")]
# Convert categorical columns to factors
df$Month <- as.factor(df$Month)
df$region <- as.factor(df$region)
df$Mountain <- as.factor(df$Mountain)
df$Cause_death <- as.factor(df$Cause_death)

# Split the data into training and testing sets
set.seed(42)
split <- sample.split(df$Cause_death, SplitRatio = 0.8)
train_data <- subset(df, split == TRUE)
test_data <- subset(df, split == FALSE)

# Train the Naive Bayes model
nb_model <- naive_bayes(Cause_death ~ Month + region + Mountain, data = train_data)

# Predict the probabilities for the new data
new_data <- data.frame(Month = factor(7), region = factor('Germany'), Mountain = factor('K2'))
new_data$Month <- factor(new_data$Month, levels = levels(train_data$Month))
new_data$region <- factor(new_data$region, levels = levels(train_data$region))
new_data$Mountain <- factor(new_data$Mountain, levels = levels(train_data$Mountain))

# Predict the probabilities for the new data
probabilities <- predict(nb_model, newdata = new_data, type = "prob")

# Print the results
print(probabilities)


modele <- glmnet(Cause_death ~ month + Mountain, data = data_classification, family = "multinomial")
prediction <- predict(modele, s = 0.01, newx = model.matrix(~ mois + montagne, new_data))