library(shiny)

# Charger UI et server
source('global.R', chdir = TRUE) # nolint
source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)