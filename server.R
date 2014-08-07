##| server.R

options(RCHART_WIDTH = 1000)
 
shinyServer(function(input, output, session) {
  
  ##| Load ui and server functions
  source('lib/ui_tabs.R', local = T)
  source('lib/server_github.R', local = T)
  
})
