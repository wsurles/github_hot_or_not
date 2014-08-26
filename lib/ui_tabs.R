##|-------------
##| Language
##|-------------

output$language <- renderUI({
  
  list(
    
    ##| Header
    fluidRow(
      column(12, offset = 0,
        h2("All Languages on Github", align = 'center'),
        column(2, offset = 4, helpModal('Explain this Tool','explain_language',inclMD("help/explain_language.md"))),          
        column(2, offset = 0, emailButton('Send Feedback', 'mailto:williamsurles@gmail.com?subject=Feedback on Github Hot or Not'))
      )
    ),
    hr(),

    ##| Chart Description
    fluidRow(
      column(12,
        h3("Stars vs Repos for all Languages on Github", align = 'center'),
        h5("This chart shows repository stars vs repos.", 
          br(), "Each bubble is a language. The colors are based on stars per repo.", align = 'center')
      )
    ),
    
    ##| Filters
    fluidRow(
      column(2, offset = 5, uiOutput("lang_language"))
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

##|-------------
##| Repo
##|-------------
output$repo_top <- renderUI({
  

  list(
    
    ##| Header
    fluidRow(
      column(8, offset = 2,
        h2("Top 500 Repos on Github", align = 'center')
      )
    ),
    
    ##| Help
    fluidRow(
      column(2, offset = 4, helpModal('Explain this Tool','explain_repos',inclMD("help/explain_repos.md"))),          
      column(2, emailButton('Send Feedback', 'mailto:williamsurles@gmail.com?subject=Feedback on Github Hot or Not'))
    ),
    # br(),
    hr(),

    ##| Chart
    fluidRow(
      column(12,
        h3("Stars vs Age in Days for Top 500 Repos", align = 'center'),
        h5("This chart shows repository stars vs the age of the repo in days.", 
          br(), "Each bubble is a repo. The colors are based on stars per week.", align = 'center')
      )
    ),
        
    ##| Filters
    fluidRow(
      column(2, offset = 3, uiOutput("repo_top_language")),
      column(2, offset = 0, uiOutput("repo_top_owner")),
      column(2, offset = 0, uiOutput("repo_top_repo"))
    ),
    fluidRow(
      column(12,
        showOutput("plot_repo_top", "nvd3"),
        h5("[Click once on chart whitespace to see tooltip on hover]", align = 'center')
      )
    ),
    
    ##| Table
    fluidRow(
      column(12,
        column(10, offset = 1, dataTableOutput('table_repo_top'))
      )
    )
  )
})

output$repo_top_lang <- renderUI({
  

  list(
    
    ##| Header
    fluidRow(
      column(8, offset = 2,
        h2("Top 100 Repos by Language on Github", align = 'center')
      )
    ),
    
    ##| Help
    fluidRow(
      column(2, offset = 4, helpModal('Explain this Tool','help_github',inclMD("help/github_hot_or_not.md"))),          
      column(2, emailButton('Send Feedback', 'mailto:williamsurles@gmail.com?subject=Feedback on Github Hot or Not'))
    ),
    hr(),

    ##| Chart
    fluidRow(
      column(12,
        h3("Stars vs Age in Days for Top 100 Repos", align = 'center'),
        h5("This chart shows repository stars vs the age of the repo in days.", 
          br(), "Each bubble is a repo. The colors are based on stars per week.", align = 'center')
      )
    ),
        
    ##| Filters
    fluidRow(
      column(2, offset = 3, uiOutput("repo_top_language_lang")),
      column(2, offset = 0, uiOutput("repo_top_owner_lang")),
      column(2, offset = 0, uiOutput("repo_top_repo_lang"))
    ),
    fluidRow(
      column(12,
        showOutput("plot_repo_top_lang", "nvd3"),
        h5("[Click once on chart whitespace to see tooltip on hover]", align = 'center')
      )
    ),
    hr(),
    
    ##| Table
    fluidRow(
      column(12,
        h3("Table of Repos", align = 'center'),
        h5("Repos are ranked by number of stars. Click the homepage or repo link to learn more.", align = 'center'),
        column(10, offset = 1, dataTableOutput('table_repo_top_lang'))
      )
    )
  )
})

##|-------------
##| Contributor
##|-------------

output$contributor <- renderUI({
  
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
