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
      uiOutput("language")),  
    
    tabPanel("Repo", value = "repo", uiOutput("repo")),
    tabPanel("Contributor", value = "contributor", uiOutput("contributor"))
	)
)