
##|-------------
##| Repo
##|-------------
output$tab_top_repos <- renderUI({
  

  list(
    ##| Header
    div(class = "jumbotron",
      column(8, offset = 2,
        h2("Top 500 Repos on Github", align = 'center')
      ),
      fluidRow(
        column(8, offset = 2, align = 'center',
          actionButton("button_modal_help_repos", "Explain this Tool", class='btn btn-primary',  style = 'color: white;'),      
          emailButton('Send Feedback', 'mailto:williamsurles@gmail.com?subject=Feedback on Github Hot or Not')
        )
      )
    ),
    bsModal("modal_help_repos", h1("Help for Repo Visualization Tool"), "button_modal_help_repos", size = "large", HTML(inclMD("help/explain_repos.md"))),

    # ##| Header
    # fluidRow(
    #   column(8, offset = 2,
    #     h2("Top 500 Repos on Github", align = 'center')
    #   )
    # ),
    
    # ##| Help
    # fluidRow(
    #   column(2, offset = 4, helpModal('Explain this Tool','explain_repos',inclMD("help/explain_repos.md"))),          
    #   column(2, emailButton('Send Feedback', 'mailto:williamsurles@gmail.com?subject=Feedback on Github Hot or Not'))
    # ),
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