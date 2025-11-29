library(shiny)

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$link(rel = "stylesheet", 
              href = "https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap")
  ),
  
  # Titre et sous-titre
  div(style = "text-align: center; margin-bottom: 20px;",
      h1("Explorez le Grand Chelem 2013"),
      div(style = "color: #34495e; font-size: 16px; max-width: 800px; margin: 0 auto;",
          "Explorez les statistiques détaillées des 4 tournois majeurs de tennis. Cliquez sur un tournoi pour découvrir ses statistiques générales et les performances des joueurs."
      )
  ),
  
  # --- Les 4 cartes principales 2x2 ---
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
               )
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
               )
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
               )
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
               )
           )
    )
  ),
  
  # --- Deux cards centrées avec les totaux ---
  fluidRow(
    column(3, offset = 3,  # décalage pour centrer la première card
           div(class = "card-horizontal totals",
               div(class = "card-content",
                   div(class = "card-text",
                       strong("Total de matchs"),
                       p(total_matchs)
                   )
               )
           )
    ),
    column(3,
           div(class = "card-horizontal totals",
               div(class = "card-content",
                   div(class = "card-text",
                       strong("Total de joueurs"),
                       p(total_players)
                   )
               )
           )
    )
  )
)