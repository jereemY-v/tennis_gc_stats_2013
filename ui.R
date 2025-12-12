header <- dashboardHeader(title = "Tennis Analytics 2013")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Tableau de Bord", tabName = "dashboard", icon = icon("tachometer-alt")),
    menuItem("Joueurs", tabName = "players", icon = icon("user")),
    menuItem("Données Brutes", tabName = "data", icon = icon("table")),
    hr(),
    selectInput("selected_gender", "Genre :", choices = c("Hommes", "Femmes")),
    selectInput("selected_tournament", "Tournoi :", choices = unique(tennis_data$Tournament))
  )
)

body <- dashboardBody(
  includeCSS("www/style.css"),
  
  tabItems(
    # --- Onglet Tableau de Bord ---
    tabItem(tabName = "dashboard",
            # Ligne des KPIs (4 boîtes)
            fluidRow(
              valueBoxOutput("matches_box", width = 3),
              valueBoxOutput("winner_box", width = 3),
              valueBoxOutput("aces_avg_box", width = 3),
              valueBoxOutput("sets_avg_box", width = 3)
            ),
            # Ligne des Graphiques
            fluidRow(
              box(
                title = "Distribution des Aces par Match", status = "success", solidHeader = TRUE, 
                plotOutput("aces_hist_plot", height = "300px"), width = 6
              ),
              box(
                title = "Ratio Fautes Directes / Coups Gagnants", status = "warning", solidHeader = TRUE, 
                plotOutput("scatter_plot", height = "300px"), width = 6
              )
            )
    ),
    
    # --- Onglet Joueurs ---
    tabItem(tabName = "players",
            fluidRow(
              box(width = 12, status = "primary",
                  selectInput("player_select", "Choisir un joueur :", choices = NULL)
              )
            ),
            fluidRow(
              valueBoxOutput("p_wins_box", width = 4),
              valueBoxOutput("p_aces_box", width = 4),
              valueBoxOutput("p_matches_box", width = 4)
            ),
            fluidRow(
              box(title = "Évolution des Performances (Coups Gagnants)", width = 12, status = "primary", solidHeader = TRUE,
                  plotOutput("player_trend_plot"))
            )
    ),
    
    # --- Onglet Données ---
    tabItem(tabName = "data",
            fluidRow(
              box(width = 12, title = "Tableau des matchs", status = "primary",
                  DTOutput("matches_table"))
            )
    )
  )
)

ui <- dashboardPage(header, sidebar, body, skin = "green")