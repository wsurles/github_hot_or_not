##| server.R

##| For running locally
# library(shiny)
# setwd("~/Dev/non_work_projects")
# runApp("app_github_hot")

options(RCHART_WIDTH = 1000)
 
shinyServer(function(input, output, session) {

  ##| Source Files
  source('lib/ui_tabs.R', local = T)
  source('lib/server_github.R', local = T)
  
})
