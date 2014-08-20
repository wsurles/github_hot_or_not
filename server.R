##| server.R

options(RCHART_WIDTH = 1000)
 
shinyServer(function(input, output, session) {
  
  load('data/repos.RData')

  ##| Load ui and server functions
  source('lib/ui_tabs.R', local = T)
  source('lib/server_language.R', local = T)
  source('lib/server_repo_top.R', local = T)
  source('lib/server_repo_top_lang2.R', local = T)


  
})
