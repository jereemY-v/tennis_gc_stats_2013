# Récupérer le vainqueur du tournoi (celui qui gagne le dernier tour dispo)
get_tournament_winner <- function(df, tournament_name, gender_val) {
  t_data <- df %>% filter(Tournament == tournament_name, Gender == gender_val)
  if(nrow(t_data) == 0) return("Inconnu")
  
  max_round <- max(t_data$Round, na.rm = TRUE)
  final_match <- t_data %>% filter(Round == max_round)
  
  if(nrow(final_match) > 0) {
    # Si Result == 1, Player1 gagne, sinon Player2
    winner <- ifelse(final_match$Result[1] == 1, final_match$Player1[1], final_match$Player2[1])
    return(winner)
  }
  return("Inconnu")
}