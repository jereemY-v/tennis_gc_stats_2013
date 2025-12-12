library(shiny)
library(shinydashboard)
library(dplyr)
library(readr)
library(DT)
library(ggplot2)
library(tidyr)

# --- Fonction de nettoyage des colonnes ---
fix_columns <- function(df) {
  # Harmonisation des noms
  if("Player 1" %in% names(df)) df <- df %>% rename(Player1 = `Player 1`)
  if("Player 2" %in% names(df)) df <- df %>% rename(Player2 = `Player 2`)
  if("ROUND" %in% names(df)) df <- df %>% rename(Round = `ROUND`)
  
  # Conversion en numérique pour éviter les erreurs de calcul
  cols_to_numeric <- c("ACE.1", "ACE.2", "FNL.1", "FNL.2", "UFE.1", "UFE.2", "WNR.1", "WNR.2", "FSP.1", "FSP.2")
  for(col in cols_to_numeric) {
    if(col %in% names(df)) df[[col]] <- as.numeric(as.character(df[[col]]))
  }
  
  return(df)
}

# --- Chargement et fusion des données ---
load_data <- function() {
  files <- list(
    list(name="AusOpen-men-2013.csv", tournament="Australian Open", gender="Hommes"),
    list(name="AusOpen-women-2013.csv", tournament="Australian Open", gender="Femmes"),
    list(name="FrenchOpen-men-2013.csv", tournament="Roland Garros", gender="Hommes"),
    list(name="FrenchOpen-women-2013.csv", tournament="Roland Garros", gender="Femmes"),
    list(name="Wimbledon-men-2013.csv", tournament="Wimbledon", gender="Hommes"),
    list(name="Wimbledon-women-2013.csv", tournament="Wimbledon", gender="Femmes"),
    list(name="USOpen-men-2013.csv", tournament="US Open", gender="Hommes"),
    list(name="USOpen-women-2013.csv", tournament="US Open", gender="Femmes")
  )
  
  all_data <- list()
  
  for (f in files) {
    if (file.exists(f$name)) {
      df <- read_csv(f$name, show_col_types = FALSE) 
      df <- fix_columns(df)
      df$Tournament <- f$tournament
      df$Gender <- f$gender
      all_data[[length(all_data) + 1]] <- df
    }
  }
  
  if(length(all_data) > 0) bind_rows(all_data) else data.frame()
}

tennis_data <- load_data()

# --- Préparation des données format "Joueur" ---
get_player_data <- function(df) {
  if(nrow(df) == 0) return(data.frame())
  
  p1 <- df %>% select(Player = Player1, Opponent = Player2, Result, 
                      FSP = FSP.1, ACE = ACE.1, WNR = WNR.1, UFE = UFE.1, 
                      Tournament, Gender, Round) %>%
    mutate(Won = ifelse(Result == 1, 1, 0))
  
  p2 <- df %>% select(Player = Player2, Opponent = Player1, Result,
                      FSP = FSP.2, ACE = ACE.2, WNR = WNR.2, UFE = UFE.2, 
                      Tournament, Gender, Round) %>%
    mutate(Won = ifelse(Result == 0, 1, 0))
  
  bind_rows(p1, p2)
}

player_data <- get_player_data(tennis_data)