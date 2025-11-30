library(shiny)

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$link(rel = "stylesheet", 
              href = "https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap"),
    tags$style(HTML("
      .card-btn { border: none !important; background: none !important; padding: 0 !important; width: 100%; text-align: left; }
      .card-btn > div { pointer-events: none; }
      .card-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; z-index: 2; }
      .card-horizontal { position: relative; }
    "))
  ),
  
  tabsetPanel(id = "pages",
    tabPanel("home", value = "home",
      div(style = "text-align: center; margin-bottom: 20px;",
          h1("Explorez le Grand Chelem 2013"),
          div(style = "color: #34495e; font-size: 16px; max-width: 800px; margin: 0 auto;",
              "Explorez les statistiques détaillées des 4 tournois majeurs de tennis. Cliquez sur un tournoi pour découvrir ses statistiques générales et les performances des joueurs."
          )
      ),
      
      # Cartes 2x2
      fluidRow(
        column(6,
               div(class = "card-horizontal",
                   div(class = "card-bar", style = "background-color: #1991D0;"),
                   div(class = "card-content",
                       div(class = "card-text",
                           strong("Australian Open"),
                           p("Localisation : Melbourne, Australie"),
                           p("Date : Janvier 2013"),
                           p("Surface : Dur")
                       ),
                       div(class = "card-image",
                           img(src = "images/australia_open.png", height = "150px")
                       )
                   ),
                   tags$a(class = "card-overlay", href = "#", 
                          onclick = "Shiny.setInputValue('tournament_selected', 'Australian Open', {priority: 'event'})")
               )
        ),
        column(6,
               div(class = "card-horizontal",
                   div(class = "card-bar", style = "background-color: #D35220;"),
                   div(class = "card-content",
                       div(class = "card-text",
                           strong("Roland Garros"),
                           p("Localisation : Paris, France"),
                           p("Date : Mai-Juin 2013"),
                           p("Surface : Terre battue")
                       ),
                       div(class = "card-image",
                           img(src = "images/french_open.png", height = "150px")
                       )
                   ),
                   tags$a(class = "card-overlay", href = "#", 
                          onclick = "Shiny.setInputValue('tournament_selected', 'Roland Garros', {priority: 'event'})")
               )
        )
      ),
      fluidRow(
        column(6,
               div(class = "card-horizontal",
                   div(class = "card-bar", style = "background-color: #006838;"),
                   div(class = "card-content",
                       div(class = "card-text",
                           strong("Wimbledon"),
                           p("Localisation : Londres, Royaume-Uni"),
                           p("Date : Juin-Juillet 2013"),
                           p("Surface : Gazon")
                       ),
                       div(class = "card-image",
                           img(src = "images/wimbledon_open.png", height = "150px")
                       )
                   ),
                   tags$a(class = "card-overlay", href = "#", 
                          onclick = "Shiny.setInputValue('tournament_selected', 'Wimbledon', {priority: 'event'})")
               )
        ),
        column(6,
               div(class = "card-horizontal",
                   div(class = "card-bar", style = "background-color: #00288C;"),
                   div(class = "card-content",
                       div(class = "card-text",
                           strong("US Open"),
                           p("Localisation : New York, USA"),
                           p("Date : Août-Septembre 2013"),
                           p("Surface : Dur")
                       ),
                       div(class = "card-image",
                           img(src = "images/us_open.png", height = "150px")
                       )
                   ),
                   tags$a(class = "card-overlay", href = "#", 
                          onclick = "Shiny.setInputValue('tournament_selected', 'US Open', {priority: 'event'})")
               )
        )
      ),
      
      # Totaux sur home
      fluidRow(
        column(3, offset = 3,
               div(class = "card-horizontal totals",
                   div(class = "card-content",
                       div(class = "card-text",
                           strong("Total de matchs"),
                           textOutput("total_matchs_home")
                       )
                   )
               )
        ),
        column(3,
               div(class = "card-horizontal totals",
                   div(class = "card-content",
                       div(class = "card-text",
                           strong("Total de joueurs"),
                           textOutput("total_players_home")
                       )
                   )
               )
        )
      )
    ),
    # ------------------- PAGE STATS -------------------
    tabPanel("stats", value = "stats",
        actionButton("go_home", "Retour à l'accueil"),

        # Card avec infos du tournoi
        div(class = "card-horizontal",
            div(class = "card-content", style = "display: flex; align-items: center; justify-content: space-between;",
                div(style = "flex-grow: 1;",
                    h2(textOutput("gc_name")),
                    p(textOutput("gc_location")),
                    p(textOutput("gc_date")),
                    p(textOutput("gc_surface"))
                ),
                div(style = "margin-left: 20px;",
                    img(src = "images/placeholder_logo.png", height = "150px")
                )
            )
        ),

        # Navbar pour Homme/Femme
        tabsetPanel(id = "gender_tabs",
            tabPanel("Hommes",
                fluidRow(
                    column(4,
                        div(class = "card-horizontal totals",
                            div(class = "card-content",
                                div(class = "card-text",
                                    strong("Total de matchs"),
                                    textOutput("total_matchs_men")
                                )
                            )
                        )
                    )
                )
            ),
            tabPanel("Femmes",
                fluidRow(
                    column(4,
                        div(class = "card-horizontal totals",
                            div(class = "card-content",
                                div(class = "card-text",
                                    strong("Total de matchs"),
                                    textOutput("total_matchs_women")
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    )
)