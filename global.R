######################
##### Librairies #####
######################
library(ggplot2)
library(tidyverse)
library(dplyr)
library(stringr)
library(plotly)
library(leaflet)
library(sf)
library(visNetwork)
library(rAmCharts)

source("scripts/conversion_gps.R")

###################################
##### Importation des données #####
###################################

data <- read_delim("data/accidents_8000.csv", delim = ",", col_names = TRUE)
data_monts <- read_delim("data/montagnes_monde.csv", delim = ";", col_names = TRUE, na = "—")
world <- st_read("data/world.shp")

data_accidents_brut <- read_delim("data/accidents_8000.csv", delim = ",", col_names = TRUE)
data_montagnes_brut <- read_delim("data/montagnes_monde.csv", delim = ";", col_names = TRUE, na = "—")

#################################
##### Renommer les colonnes #####
#################################

colnames(data)[c(3, 4)] <- c("region", "Cause_death")
colnames(data_monts)[c(2, 9)] <- c("Mountain", "Parent_mountain")

##############################
##### Valeurs manquantes #####
##############################

# On remplace les valeurs manquantes pour la cause de l'accident par Unknown
data <- data |>
  replace_na(list(Cause_death = "Unknown"))

data <- data |> na.omit() # On supprime les dernières valeurs manquantes
# Les 2 dernières valeurs manquantes sont des alpinistes inconnus (Unknown porter et Unnamed)
# On ne peut donc pas imputer leur nationalité en faisant une recherche par leur nom

##########################################################
##### Séparer la colonne date en année, mois et jour #####
##########################################################
data <- data %>%
  mutate(Date = ymd(Date), # on souhaite garder la colonne Date pour une utilisation ultérieure
         Year = year(Date),
         Month = month(Date),
         Day = day(Date))

###############################
##### Ajouter les saisons #####
###############################

data <- data |>
  mutate(
    Saison = case_when(
      grepl(1, Month) ~ "Hiver",
      grepl(2, Month) ~ "Hiver",
      grepl(3, Month) ~ "Printemps",
      grepl(4, Month) ~ "Printemps",
      grepl(5, Month) ~ "Printemps",
      grepl(6, Month) ~ "Ete",
      grepl(7, Month) ~ "Ete",
      grepl(8, Month) ~ "Ete",
      grepl(9, Month) ~ "Automne",
      grepl(10, Month) ~ "Automne",
      grepl(11, Month) ~ "Automne",
      grepl(12, Month) ~ "Hiver",
    )
  )

###########################################################
##### Modification des catégories de cause d'accident #####
###########################################################

data <- data %>%
  mutate(Cause_death = tolower(Cause_death)) %>%
  mutate(Cause_death = case_when(
    grepl('serac', Cause_death) ~ 'Avalanche',
    grepl('fall|fell', Cause_death) ~ 'Fall',
    grepl('disappeared|disappearance', Cause_death) ~ 'Disappeared',
    grepl('illnes|altitude|cardiac|stroke|heart|pneumonia|pulmonary|edema|thrombosis|hemorrhage|hape|hace|respiratory|hypothermia|frostbite|cold|organ|cerebral|sickness|coma|fever', Cause_death) ~ 'Illness',
    grepl('avalanche', Cause_death) ~ 'Avalanche',
    grepl('storm|weather|lightning', Cause_death) ~ 'Storm',
    grepl('exposure', Cause_death) ~ 'Exposure',
    grepl('exhaustion|collapsed', Cause_death) ~ 'Exhaustion',
    TRUE ~ 'Other'
  ))


#########################################
##### Modification des nationalités #####
#########################################

data <- data %>%
  mutate(region = if_else(grepl('Australia', region), 'Australia', region),
         region = if_else(grepl('China', region), 'China', region),
         region = if_else(grepl('Czech', region), 'Czech Republic', region),
         region = if_else(grepl('United States', region), 'United States', region),
         region = if_else(grepl('Germany', region), 'Germany', region),
         region = if_else(grepl('Yugoslavia', region), 'Yugoslavia', region),
         region = if_else(grepl('British Raj', region), 'India', region)
  )

##############################################
##### Modification du nom d'une montagne #####
##############################################
data_monts <- data_monts %>% 
  mutate(Parent_mountain = ifelse(Parent_mountain == "Dhaulagiri", "Dhaulagiri I", Parent_mountain))

#########################################################
##### Convertion des coordonnées GPS en lat et long #####
#########################################################

# Séparatin de la colonne coordinates en c_lat et c_long
data_monts <- data_monts |> separate_wider_delim(coordinates, delim = " ", names = c("c_lat", "c_long"))

# Séparation de c_lat en degré, minute, seconde et direction
data_monts <- data_monts |>
  separate(c_lat, sep = "[°′″]+", into = c("lat_deg", "lat_min", "lat_sec", "lat_dir"))

# Séparation de c_long en degré, minute, seconde et direction
data_monts <- data_monts |>
  separate(c_long, sep = "[°′″]+", into = c("long_deg", "long_min", "long_sec", "long_dir"))

# Insertion des colonnes latitude et longitude dans le data frame
data_monts <- data_monts |>
  mutate(
    latitude = convert_coordinates(lat_deg, lat_min, lat_sec, lat_dir),
    longitude = convert_coordinates(long_deg, long_min, long_sec, long_dir)
  ) |>
  select(-lat_deg, -lat_min, -lat_sec, -lat_dir, -long_deg, -long_min, -long_sec, -long_dir)

########################################################
##### Séléction des montagnes de +8000m d'altitude #####
########################################################

data_monts_8000 <- data_monts |> filter(Height_m >= 8000)

######################################
##### Fusionner les 2 data frame #####
######################################

data_total <- data |> merge(data_monts_8000, by = "Mountain") |>
  select(c("Mountain", "Date", "Name", "region", "Cause_death", "Year", "Month", "Day", "Saison", "Height_m", "Parent_mountain", "ascents_first","country", "latitude", "longitude"))

########################################
##### Modifier le data frame world #####
########################################

# Supprimer les colonnes non nécessaires (selon vos besoins)
world <- world[, c("sovereignt", "geometry")]
colnames(world)[1] <- "region"

# Modifier la colonne "region" dans le dataframe data_accident_nat
data_accident_nat <- data |>
  mutate(region = ifelse(region == "United States", "United States of America", region)) |>
  group_by(region) |>
  summarise(Nombre = n()) |>
  right_join(world, by = "region") |>
  mutate(Nombre = replace_na(Nombre, 0)) |>
  st_as_sf()

