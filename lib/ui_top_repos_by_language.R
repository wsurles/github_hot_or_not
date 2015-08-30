
output$tab_top_repos_by_language <- renderUI({
  
  list(
    ##| Header  
    div(class = "jumbotron",
      column(8, offset = 2,
        h2("Top 100 Repos by Language on Github", align = 'center')
      ),
      fluidRow(
        column(8, offset = 2, align = 'center',
          actionButton("button_modal_help_top_repo", "Explain this Tool", class='btn btn-primary',  style = 'color: white;'),      
          emailButton('Send Feedback', 'mailto:williamsurles@gmail.com?subject=Feedback on Github Hot or Not')
        )
      )
    ),
    bsModal("modal_help_top_repo", h1("Help for Top Repo Visualization Tool"), "button_modal_help_top_repo", size = "large", HTML(inclMD("help/explain_repos.md"))),
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
      column(12, h3("Table of Repos", align = 'center')),
      column(12, h5("Repos are ranked by number of stars. Click the homepage or repo link to learn more.", align = 'center')),
      # div(tabPanel("Table", dataTableOutput('table_repo_top_lang')), style = 'width:500px;'),
      # tags$head(tags$style(type="text/css", ".container-fluid {  max-width: 950px }"))
      column(12, offset = 0, dataTableOutput('table_repo_top_lang'))
    )
  )
})
