# queries.R

# -------------------------------------------------------------------------
# 1. Chargement et Préparation des Données
# -------------------------------------------------------------------------

load_all_data <- function(data_path = "data") {
  # Lister tous les fichiers CSV
  fichiers <- list.files(data_path, pattern = "*.csv", full.names = TRUE)
  
  # Identifier les fichiers par tournoi
  tournament_files <- list(
    "Australian Open" = fichiers[grepl("AusOpen", fichiers)],
    "Roland Garros"   = fichiers[grepl("FrenchOpen", fichiers)],
    "Wimbledon"       = fichiers[grepl("Wimbledon", fichiers)],
    "US Open"         = fichiers[grepl("USOpen", fichiers)]
  )
  
  # Lire et structurer les données
  all_data <- lapply(tournament_files, function(files) {
    list(
      men   = files[grepl("-men-", files)] %>% lapply(read_csv, show_col_types = FALSE) %>% bind_rows(),
      women = files[grepl("-women-", files)] %>% lapply(read_csv, show_col_types = FALSE) %>% bind_rows()
    )
  })
  
  return(all_data)
}

# -------------------------------------------------------------------------
# 2. Calcul des Statistiques Globales (Accueil)
# -------------------------------------------------------------------------

compute_global_stats <- function(all_data) {
  # Total des matchs
  total_matchs <- sum(sapply(all_data, function(t) {
    nrow(t$men) + nrow(t$women)
  }))
  
  # Total des joueurs uniques
  total_players <- all_data %>%
    lapply(function(t) bind_rows(t$men, t$women)) %>%
    bind_rows() %>%
    select(Player1, Player2) %>%
    pivot_longer(everything(), values_to = "Player") %>%
    distinct(Player) %>%
    nrow()
  
  return(list(matchs = total_matchs, players = total_players))
}

# -------------------------------------------------------------------------
# 3. Fonctions de "Requêtes" (Getters)
# -------------------------------------------------------------------------

# Récupérer les données brutes pour un tournoi et un genre
get_tournament_data <- function(all_data, gc_name, gender = "men") {
  # Sécurité : vérifier si le tournoi existe
  if (!gc_name %in% names(all_data)) return(NULL)
  all_data[[gc_name]][[gender]]
}

# Compter le nombre de matchs pour un tournoi et un genre
get_match_count <- function(all_data, gc_name, gender = "men") {
  data <- get_tournament_data(all_data, gc_name, gender)
  if (is.null(data)) return(0)
  return(nrow(data))
}

# Récupérer les infos statiques (Méta-données)
get_tournament_info <- function(gc_name) {
  info_map <- list(
    "Australian Open" = list(name="Australian Open", location="Melbourne, Australia", date="January 2013", surface="Hard"),
    "Roland Garros"   = list(name="Roland Garros", location="Paris, France", date="May-June 2013", surface="Clay"),
    "Wimbledon"       = list(name="Wimbledon", location="London, UK", date="June-July 2013", surface="Grass"),
    "US Open"         = list(name="US Open", location="New York, USA", date="August-September 2013", surface="Hard")
  )
  return(info_map[[gc_name]])
}

# Ajoute cette fonction à la fin de queries.R, dans la section "Getters"

get_avg_aces <- function(all_data, gc_name, gender = "men") {
  # 1. Récupérer les données du tournoi sélectionné
  data <- get_tournament_data(all_data, gc_name, gender)
  
  if (is.null(data)) return(0)
  
  # 3. Calculer la moyenne : (Aces J1 + Aces J2) pour chaque match, puis moyenne globale
  avg <- mean(data$ACE.1 + data$ACE.2, na.rm = TRUE)
  
  # 4. Arrondir le résultat
  return(round(avg, 1))
}

get_avg_sets <- function(all_data, gc_name, gender = "men") {
  data <- get_tournament_data(all_data, gc_name, gender)
  
  if (is.null(data) || nrow(data) == 0) return(0)
  
  # 1. Calcul de la moyenne
  resultat_tibble <- data %>%
    # On utilise FNL1 + FNL2 pour avoir le vrai total de sets du match
    mutate(total_sets_match = FNL.1 + FNL.2) %>%
    summarise(moyenne = mean(total_sets_match, na.rm = TRUE))
  
  # 2. EXTRACTION (C'est ici que l'erreur [object Object] est corrigée)
  # pull() permet de sortir la valeur du tableau pour en faire un chiffre simple
  valeur_numerique <- pull(resultat_tibble, moyenne)
  
  return(round(valeur_numerique, 2))
}