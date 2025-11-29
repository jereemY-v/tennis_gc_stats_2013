library(dplyr)
library(readr)
library(tidyr)

# Lister tous les fichiers CSV
fichiers <- list.files("data", pattern = "*.csv", full.names = TRUE)

# Lire et combiner tous les fichiers
all_data <- fichiers %>%
  lapply(read_csv) %>%
  bind_rows()

# Total de matchs = nombre de lignes
total_matchs <- all_data %>%
  summarise(total = n()) %>%
  pull(total)

# Total de joueurs distincts
total_players <- all_data %>%
  select(Player1, Player2) %>%           # colonnes avec les joueurs
  pivot_longer(everything(), values_to = "Player") %>%  # mettre tous les joueurs dans une seule colonne
  distinct(Player) %>%                    # garder uniquement les joueurs uniques
  nrow()                                  # compter le nombre