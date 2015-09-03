##|-------------
##| Language
##|-------------

output$tab_languages <- renderUI({
  
  list(
    ##| Header
    div(class = "jumbotron",
      column(8, offset = 2,
        h2("All Languages on GitHub", align = 'center')
      ),
      fluidRow(
        column(8, offset = 2, align = 'center',
          actionButton("button_modal_help_language", "Explain this Tool", class='btn btn-primary',  style = 'color: white;'),      
          emailButton('Send Feedback', 'mailto:williamsurles@gmail.com?subject=Feedback on GitHub Hot or Not')
        )
      )
    ),
    bsModal("modal_help_language", h1("Help for Language Visualization Tool"), "button_modal_help_language", size = "large", HTML(inclMD("help/explain_language.md"))),


    ##| Chart Description
    fluidRow(
      column(12,
        h3("Stars vs Repos for all Languages on GitHub", align = 'center'),
        h5("This chart shows repository stars vs repos.", 
          br(), "Each bubble is a language. The colors are based on stars per repo.", align = 'center')
      )
    ),
    
    ##| Filters
    fluidRow(
      column(4, offset = 4, uiOutput("lang_language"), align='center')
    ),
    
    ##| Chart 
    fluidRow(
      column(12,
        showOutput("plot_language", "nvd3"),
        h5("[Click once on chart whitespace to see tooltip on hover]", align = 'center')
      )
    ),
    hr(),
    
    #| Table
    fluidRow(
      column(12,
        h3("Table of all Languages", align = 'center'),
        h5("Languages are ranked by # of repos", align = 'center'),
        column(10, offset = 1, dataTableOutput('table_language'))
      )
    )
  )
})
