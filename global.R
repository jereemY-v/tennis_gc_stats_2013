library(dplyr)
library(readr)
library(tidyr)

# Lister tous les fichiers CSV
fichiers <- list.files("data", pattern = "*.csv", full.names = TRUE)

# Grouper les fichiers par tournoi et par genre
tournament_files <- list(
  "Australian Open" = fichiers[grepl("AusOpen", fichiers)],
  "Roland Garros"    = fichiers[grepl("FrenchOpen", fichiers)],
  "Wimbledon"        = fichiers[grepl("Wimbledon", fichiers)],
  "US Open"          = fichiers[grepl("USOpen", fichiers)]
)

# Lire les fichiers pour chaque tournoi et séparer Homme/Femme
all_data_list <- lapply(tournament_files, function(files) {
  list(
    men   = files[grepl("-men-", files)] %>% lapply(read_csv) %>% bind_rows(),
    women = files[grepl("-women-", files)] %>% lapply(read_csv) %>% bind_rows()
  )
})

# Fonction utilitaire pour compter les matchs
count_total_matches <- function(data) {
  nrow(data)
}

# Totaux globaux
total_matchs <- sum(sapply(all_data_list, function(t) {
  count_total_matches(t$men) + count_total_matches(t$women)
}))

total_players <- all_data_list %>%
  lapply(function(t) bind_rows(t$men, t$women)) %>%
  bind_rows() %>%
  select(Player1, Player2) %>%
  pivot_longer(everything(), values_to = "Player") %>%
  distinct(Player) %>%
  nrow()

# Obtenir les données pour un tournoi spécifique et un genre
get_tournament_data <- function(gc_name, gender = "men") {
  all_data_list[[gc_name]][[gender]]
}

# Nombre total de matchs pour un tournoi spécifique et un genre
get_tournament_stats <- function(gc_name, gender = "men") {
  count_total_matches(get_tournament_data(gc_name, gender))
}