shinyUI(
	
  navbarPage(
  
    id = "nbp",
		title = "Github Hot or Not", 
		theme = "bootstrap.css",
    collapsable = TRUE,
    footer = fluidRow(hr(),
              column(12, offset = 0, 
                HTML('&nbsp;'),
                span(strong("Footer Text"), style = "font-family:arial;color:black;font-size:12px;")
              )
             ),
    tabPanel("Language", value = "language", 
      includeHTML("www/data_hub_scripts.js"),
      includeHTML("www/get_font_awesome.html"),
      uiOutput("language")
    ),
    navbarMenu("Repo", value = 'repo',
      tabPanel("Top 500", id = 'test', uiOutput("repo_top")),
      tabPanel("Top 100 by Language", uiOutput("repo_top_lang"))
    ),
    tabPanel("Contributor", value = "contributor", uiOutput("contributor"))
	)
)