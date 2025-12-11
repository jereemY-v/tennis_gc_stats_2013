# server.R
server <- function(input, output, session) {

  # -----------------------------
  # 1️⃣ Navigation & Sélection
  # -----------------------------
  selected_gc <- reactiveVal(NULL)
  
  observeEvent(input$tournament_selected, {
    selected_gc(input$tournament_selected)
    updateTabsetPanel(session, "pages", selected = "stats")
  })
  
  observeEvent(input$go_home, {
    updateTabsetPanel(session, "pages", selected = "home")
  })
  
  # -----------------------------
  # 2️⃣ Infos du tournoi (En-tête page stats)
  # -----------------------------
  tournament_meta <- reactive({
    req(selected_gc())
    get_tournament_info(selected_gc())
  })
  
  output$gc_name     <- renderText({ req(tournament_meta()); paste("Tournoi :", tournament_meta()$name) })
  output$gc_location <- renderText({ req(tournament_meta()); paste("Localisation :", tournament_meta()$location) })
  output$gc_date     <- renderText({ req(tournament_meta()); paste("Date :", tournament_meta()$date) })
  output$gc_surface  <- renderText({ req(tournament_meta()); paste("Surface :", tournament_meta()$surface) })
  
  # -----------------------------
  # 3️⃣ Statistiques spécifiques (Page stats)
  # -----------------------------
  output$total_matchs_men <- renderText({
    req(selected_gc())
    # Appel à la fonction définie dans queries.R
    get_match_count(TENNIS_DATA, selected_gc(), "men")
  })
  
  output$total_matchs_women <- renderText({
    req(selected_gc())
    get_match_count(TENNIS_DATA, selected_gc(), "women")
  })

  # --- Calculs aces pour les Hommes ---
  output$avg_aces_men <- renderText({
    req(selected_gc())
    get_avg_aces(TENNIS_DATA, selected_gc(), "men")
  })
  # --- Calculs aces pour les Femmes ---
  output$avg_aces_women <- renderText({
    req(selected_gc())
    get_avg_aces(TENNIS_DATA, selected_gc(), "women")
  })
  
  # --- Moyenne Sets Hommes ---
  output$avg_sets_men <- renderText({
    req(selected_gc())
    get_avg_sets(TENNIS_DATA, selected_gc(), "men")
  })
  
  # --- Moyenne Sets Femmes ---
  output$avg_sets_women <- renderText({
    req(selected_gc())
    get_avg_sets(TENNIS_DATA, selected_gc(), "women")
  })
  
  # -----------------------------
  # 4️⃣ Totaux globaux (Page Home)
  # -----------------------------
  # On utilise l'objet GLOBAL_STATS calculé dans global.R
  output$total_matchs_home <- renderText({ paste(GLOBAL_STATS$matchs) })
  output$total_players_home <- renderText({ paste(GLOBAL_STATS$players) })
  
  # -----------------------------
  # 5️⃣ (Optionnel) Tableau de données
  # -----------------------------
  output$gc_table <- renderTable({
    req(selected_gc())
    bind_rows(
      get_tournament_data(TENNIS_DATA, selected_gc(), "men"),
      get_tournament_data(TENNIS_DATA, selected_gc(), "women")
    )
  })
}