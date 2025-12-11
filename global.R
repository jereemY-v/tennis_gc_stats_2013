# global.R
library(dplyr)
library(readr)
library(tidyr)
library(shiny)

# 1. Charger le fichier contenant la logique
source("queries.R")

# 2. Charger les données en mémoire (une seule fois au lancement)
# On suppose que le dossier "data" est à la racine de l'app
TENNIS_DATA <- load_all_data("data")

# 3. Pré-calculer les stats globales pour la page d'accueil
GLOBAL_STATS <- compute_global_stats(TENNIS_DATA)