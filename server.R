server <- function(input, output, session) {

  # -----------------------------
  # 1️⃣ Tournoi sélectionné
  # -----------------------------
  selected_gc <- reactiveVal(NULL)
  
  # Observer les clics sur les cartes (tournament_selected envoyé depuis l'UI)
  observeEvent(input$tournament_selected, {
    selected_gc(input$tournament_selected)
    updateTabsetPanel(session, "pages", selected = "stats")
  })
  
  # Bouton retour à l'accueil
  observeEvent(input$go_home, {
    updateTabsetPanel(session, "pages", selected = "home")
  })
  
  # -----------------------------
  # 2️⃣ Infos du tournoi
  # -----------------------------
  tournament_info <- reactive({
    req(selected_gc())
    info_map <- list(
      "Australian Open" = list(name="Australian Open", location="Melbourne, Australia", date="January 2013", surface="Hard"),
      "Roland Garros"   = list(name="Roland Garros", location="Paris, France", date="May-June 2013", surface="Clay"),
      "Wimbledon"       = list(name="Wimbledon", location="London, UK", date="June-July 2013", surface="Grass"),
      "US Open"         = list(name="US Open", location="New York, USA", date="August-September 2013", surface="Hard")
    )
    info_map[[selected_gc()]]
  })
  
  output$gc_name <- renderText({ req(tournament_info()); paste("Tournoi :", tournament_info()$name) })
  output$gc_location <- renderText({ req(tournament_info()); paste("Localisation :", tournament_info()$location) })
  output$gc_date <- renderText({ req(tournament_info()); paste("Date :", tournament_info()$date) })
  output$gc_surface <- renderText({ req(tournament_info()); paste("Surface :", tournament_info()$surface) })
  
  # -----------------------------
  # 3️⃣ Total de matchs par genre pour la navbar
  # -----------------------------
  output$total_matchs_men <- renderText({
    req(selected_gc())
    get_tournament_stats(selected_gc(), "men")
  })
  
  output$total_matchs_women <- renderText({
    req(selected_gc())
    get_tournament_stats(selected_gc(), "women")
  })
  
  # -----------------------------
  # 4️⃣ Totaux sur la page home
  # -----------------------------
  output$total_matchs_home <- renderText({ paste(total_matchs) })
  output$total_players_home <- renderText({ paste(total_players) })
  
  # -----------------------------
  # 5️⃣ (Optionnel) tableau complet du tournoi
  # -----------------------------
  output$gc_table <- renderTable({
    req(selected_gc())
    # Par défaut on peut afficher Homme et Femme séparément si besoin
    bind_rows(
      get_tournament_data(selected_gc(), "men"),
      get_tournament_data(selected_gc(), "women")
    )
  })
}