

##|-------------
##| Contributor
##|-------------

output$tab_contributor <- renderUI({
  
  list(
    
    ##| Header
    fluidRow(
      column(8, offset = 2,
        h2("Top Contributors by Language on Github", align = 'center'),
        h4("Based on Contributors to the top 100 repos in a language", align = 'center')
      )
    ),
    
    ##| Help
    fluidRow(
      column(2, offset = 4, helpModal('Explain this Tool','help_owner_lang',inclMD("help/github_hot_or_not.md"))),          
      column(2, emailButton('Send Feedback', 'mailto:williamsurles@gmail.com?subject=Feedback on Github Hot or Not'))
    ),
    hr(),

    ##| Chart
    fluidRow(
      column(12,
        h3("Chart of Top 50 Contributors", align = 'center'),
        h5("Choose a repo or a contributor to drill down", align = 'center')
      )
    ),
        
    ##| Filters
    fluidRow(
      column(2, offset = 3, uiOutput("actor_lang")),
      column(2, offset = 0, uiOutput("actor_repo_lang")),
      column(2, offset = 0, uiOutput("actor_actor_lang"))
    ),
    fluidRow(
      column(12,
        showOutput("plot_actor_lang", "nvd3")
      )
    ),
    hr(),
    
    ##| Table
    fluidRow(
      column(12,
        h3("Table of top 100 contributors by repo", align = 'center'),
        h5("Ranked by push and create events. Click the github or blog link to learn more about each contributor.", align = 'center'),
        column(10, offset = 1, dataTableOutput('table_actor_lang'))
      )
    )
  )

})
