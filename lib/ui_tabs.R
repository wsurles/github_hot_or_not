
##|----------------
##| Net Worth
##|----------------

output$github <- renderUI({
  

  list(
    
    ##| Header
    fluidRow(
      column(8, offset = 2,
        h2("Github Repos - Hot or Not", align = 'center'),
        h5("This tools shows the top 100 starred gitub repos for the chosen language. ", align = 'center')
      )
    ),
    
    ##| Help
    fluidRow(
      column(3, offset = 3, helpModal('Explain this Tool','help_github',inclMD("help/github_hot_or_not.md"))),          
      column(2, offset = 0, emailButton('Send Feedback', 'mailto:williamsurles@gmail.com?subject=Feedback on Shiny Workshop'))
    ),
    # br(),
    hr(),

    ##| Filters
    fluidRow(
      column(2, offset = 1, uiOutput("language")),
      column(3, offset = 0, uiOutput("repo_owner"))
    ),
    hr(),

    ##| Chart
    fluidRow(
      column(12,
        h3("Stars vs Age in Days for Top 100 Repos", align = 'center'),
        h5("This chart shows repository stars vs the age of the repo in days.", 
          br(), "Each bubble is a repo. The colors are based on stars per day.", align = 'center'),
        showOutput("plot_github", "nvd3")
      )
    ),
    hr(),
    
    ##| Table
    fluidRow(
      column(12,
        column(10, offset = 1, dataTableOutput('table_github'))
      )
    )
  )
})

output$examples <- renderUI({

  list()

})

output$page1 <- renderUI({
  
  h3('Page 1')

})

output$page2 <- renderUI({
  
  h3('Page 2')

})