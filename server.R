server <- function(input, output, session) {
  
  # --- Données Réactives ---
  data_filtered <- reactive({
    req(tennis_data)
    tennis_data %>% 
      filter(Gender == input$selected_gender, 
             Tournament == input$selected_tournament)
  })
  
  # --- Mise à jour liste joueurs ---
  observe({
    req(data_filtered())
    players <- unique(c(data_filtered()$Player1, data_filtered()$Player2))
    updateSelectInput(session, "player_select", choices = sort(players))
  })
  
  # --- KPIs Dashboard ---
  
  output$matches_box <- renderValueBox({
    valueBox(
      nrow(data_filtered()), "Matchs Joués", icon = icon("list"),
      color = "green"
    )
  })
  
  output$winner_box <- renderValueBox({
    winner <- get_tournament_winner(tennis_data, input$selected_tournament, input$selected_gender)
    valueBox(
      winner, "Vainqueur", icon = icon("trophy"),
      color = "yellow"
    )
  })
  
  output$aces_avg_box <- renderValueBox({
    df <- data_filtered()
    # Somme des aces P1 + P2 divisée par le nombre de matchs
    total_aces <- sum(df$ACE.1, na.rm=TRUE) + sum(df$ACE.2, na.rm=TRUE)
    avg_aces <- round(total_aces / nrow(df), 1)
    
    valueBox(
      avg_aces, "Aces / Match (Moy)", icon = icon("bolt"),
      color = "purple"
    )
  })
  
  output$sets_avg_box <- renderValueBox({
    df <- data_filtered()
    # Calcul du nombre de sets total par match (FNL.1 + FNL.2 = Sets gagnés par P1 + Sets gagnés par P2)
    # Note : FNL = Final Number of Games Won (souvent utilisé pour les sets dans ces datasets, ex: 3-0, 3-1)
    # Si FNL est vide, on ignore
    total_sets <- sum(df$FNL.1, na.rm=TRUE) + sum(df$FNL.2, na.rm=TRUE)
    avg_sets <- round(total_sets / nrow(df), 2)
    
    valueBox(
      avg_sets, "Sets / Match (Moy)", icon = icon("columns"),
      color = "blue"
    )
  })
  
  # --- Graphiques Dashboard ---
  
  output$aces_hist_plot <- renderPlot({
    df <- data_filtered()
    # On combine les aces des deux joueurs pour voir la distribution globale par match
    aces_per_match <- df$ACE.1 + df$ACE.2
    
    ggplot(data.frame(aces = aces_per_match), aes(x = aces)) +
      geom_histogram(fill = "#00a65a", bins = 15, color = "white", alpha = 0.8) +
      labs(x = "Nombre d'Aces par match", y = "Fréquence") +
      theme_minimal()
  })
  
  output$scatter_plot <- renderPlot({
    # Fautes directes vs Gagnants (Vue Joueur 1 pour simplifier le nuage de points)
    ggplot(data_filtered(), aes(x = WNR.1, y = UFE.1)) +
      geom_point(color = "#f39c12", size = 3, alpha = 0.6) +
      geom_smooth(method = "lm", color = "#dd4b39", se = FALSE, linetype = "dashed") +
      labs(x = "Coups Gagnants (Winners)", y = "Fautes Directes (Unforced Errors)") +
      theme_minimal()
  })
  
  # --- Logique Joueurs ---
  
  player_specific <- reactive({
    req(input$player_select)
    player_data %>% 
      filter(Player == input$player_select,
             Gender == input$selected_gender,
             Tournament == input$selected_tournament)
  })
  
  output$p_wins_box <- renderValueBox({
    wins <- sum(player_specific()$Won, na.rm=TRUE)
    valueBox(wins, "Victoires", icon = icon("thumbs-up"), color = "aqua")
  })
  
  output$p_aces_box <- renderValueBox({
    aces <- sum(player_specific()$ACE, na.rm=TRUE)
    valueBox(aces, "Aces Totaux", icon = icon("bullseye"), color = "green")
  })
  
  output$p_matches_box <- renderValueBox({
    nb <- nrow(player_specific())
    valueBox(nb, "Matchs Joués", icon = icon("gamepad"), color = "blue")
  })
  
  output$player_trend_plot <- renderPlot({
    dat <- player_specific()
    if(nrow(dat) > 0) {
      ggplot(dat, aes(x = factor(Round), y = WNR, group = 1)) +
        geom_line(color = "#3c8dbc", size = 1.2) +
        geom_point(size = 4, aes(color = as.factor(Won))) +
        scale_color_manual(values = c("0" = "red", "1" = "green"), labels = c("Défaite", "Victoire"), name = "Résultat") +
        labs(x = "Tour (Round)", y = "Coups Gagnants", 
             title = paste("Parcours de", input$player_select)) +
        theme_minimal()
    }
  })
  
  # --- Tableau Données ---
  output$matches_table <- renderDT({
    datatable(data_filtered() %>% select(Round, Player1, Player2, Result, FNL.1, FNL.2, ACE.1, ACE.2), 
              options = list(pageLength = 10, scrollX = TRUE),
              rownames = FALSE)
  })
}