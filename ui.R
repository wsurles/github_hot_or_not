library(shiny)
library(shinydashboard)
library(shinyBS)

shinyUI(	
  dashboardPage(
    dashboardHeader(title = 'Github Hot or Not'),
    dashboardSidebar(
      sidebarMenu(
        menuItem('Languages', tabName = 'languages'),
        menuItem('Repos', tabName = 'repos',
          menuSubItem('Top Repos', tabName = 'top_repos'),
          menuSubItem('Top Repos by Language', tabName = 'top_repos_by_language')
        )
      )
    ),
    dashboardBody(
      tags$head(tags$script(src="custom_scripts.js")),
      includeCSS("www/custom_style.css"),
      tabItems(
        tabItem(tabName = "languages", uiOutput("tab_languages")),
        tabItem(tabName = "top_repos", uiOutput("tab_top_repos")),
        tabItem(tabName = "top_repos_by_language", uiOutput("tab_top_repos_by_language"))
      )
    )      
	)
)