shinyUI(
	
  navbarPage(
  
    id = "nbp",
		title = "Data Hub", 
		theme = "bootstrap.css",
    collapsable = TRUE,
    footer = fluidRow(hr(),
              column(12, offset = 0, 
                HTML('&nbsp;'),
                span(strong("Footer Text"), style = "font-family:arial;color:black;font-size:12px;")
              )
             ),

    tabPanel("rCharts", value = "rcharts",
    	
      includeHTML("www/data_hub_scripts.js"),
      includeHTML("www/get_font_awesome.html"),
      
      navlistPanel(
        
        id="nlp",
        widths=c(2,10),
        
        "Header",
        
        tabPanel("GitHub", value = "github", uiOutput("github")),
        tabPanel("Examples", value = "examples", uiOutput("examples"))
    
      )
    ),

    tabPanel("Tab 2", value = "tab2",
    	
      navlistPanel(
        
        id="nlp",
        widths=c(2,10),
        
        "Header",
        
        tabPanel("Page 1", value = "page1", uiOutput('page1')),
        tabPanel("Page 2", value = "page2", uiOutput('page2'))
    
      )
    )
	)
)