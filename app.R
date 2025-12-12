# app.R
source("global.R")
source("queries.R")
source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)