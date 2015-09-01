##| server.R

## runApp('.', launch.browser=T)
options(RCHART_WIDTH = 1000)
 
shinyServer(function(input, output, session) {
  
  # load('data/repos.RData')

  createReactiveValue <- function(v,name) {
    v[[name]] <- 0
    return(v)
  }
  v <- reactiveValues()
  v <- createReactiveValue(v,'update_list_lang')
  
  ##| Load ui and server functions
  source('lib/ui_languages.R', local = T)
  source('lib/ui_top_repos.R', local = T)
  source('lib/ui_top_repos_by_language.R', local = T)
  
  source('lib/server_languages.R', local = T)
  source('lib/server_top_repos.R', local = T)
  source('lib/server_top_repos_by_language.R', local = T)
  
})
