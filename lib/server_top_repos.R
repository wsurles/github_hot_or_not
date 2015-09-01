
##| --------------------------------------------
##| Crunch Data Functions
##| --------------------------------------------

getDataTopRepos <- reactive({
  load('data/df_top_repos.RData')
  df2 <- df_top_repos
  return(df2)
})

filterRepoTop <- reactive({
  ##| Fitler on Owner
  ##| - Change the -group- for all subs that do not match owner list
  ##| - This allows all subs to be plotted and maintain context
  ##| - '' group will be plotted in a light color
  ##| - Rearrange after changing group to maintain color order
    
  df3 <- getDataTopRepos()
  #  input <- data.frame(repo_top_language = 'JavaScript')
  
  ## Filter dots 
  if (is.null(input$repo_top_language) == F | 
      is.null(input$repo_top_owner) == F  | 
      is.null(input$repo_top_repo) == F) {
        df3$group[ 
          !(df3$language %in% input$repo_top_language) & 
          !(df3$owner %in% input$repo_top_owner) & 
          !(df3$repo_name %in% input$repo_top_repo)] <- ''
  }
  
  df3 <- arrange(df3, group)
  
  return(df3)
                
})


setColorRepoTop <- function(df2, df3) {

  color_list <- c('#E5E5E5', 'steelblue','forestgreen', 'orange', 'orangered')

  groups <- unique(levels(df2$group))

  tmp <- as.data.frame(table(df3$group))
  tmp$Var1 <- as.character(tmp$Var1)
  groups_filtered <-  filter(tmp, Freq > 0)

  color <- color_list[groups %in% groups_filtered$Var1]
  
  return(color)

}

##| --------------------------------------------
##| Plot Functions
##| --------------------------------------------

createPlotRepoTop <- reactive({
  
  df2 <- getDataTopRepos()
  df3 <- filterRepoTop()
  color <- setColorRepoTop(df2,df3)
  
  df3 <- select(df2, stars, log_stars, age_days, group, log_forks, 
                repo_name, language, stars_per_week, 
                forks, date_created_str)
  
  p2 <- nPlot(log_stars ~ age_days, group = 'group', data = df3, type = 'scatterChart')
  p2$yAxis(axisLabel = 'Stars')
  p2$xAxis(axisLabel = 'Age in Days')
  p2$chart(color = color)
  p2$chart(size = '#! function(d){return d.forks} !#')
  p2$yAxis(tickFormat="#! function(d) {return Math.round(Math.pow(10, d));}!#")
  p2$chart(tooltipContent = "#!
          function(key, x, y, d){ 
            return '<h3>' + d.point.repo_name + '</h3>' +
            '<p> <b> Language = ' + d.point.language + ' </b> </p>' +
            '<p>' + '<b>' +  d.point.stars_per_week + ' Stars/Week' + '</b>' +'</p>' +
            '<p> Age in Days = ' +  d.point.age_days + '</p>' +                    
            '<p> Stars = ' +  d.point.stars + '</p>' +          
            '<p> Forks = ' +  d.point.forks + '</p>' +       
            '<p> Date Created = ' +  d.point.date_created_str + '</p>'
          }
          !#")
  
  return(p2)
  
})

##| --------------------------------------------
##| Render UI Functions
##| --------------------------------------------

##| Language
output$repo_top_language <- renderUI({
  
  df2 <- getDataTopRepos()
  lang_list <- sort(unique(df2$language))
  
  selectizeInput(inputId = "repo_top_language",
              label = h4("Language:"),
              choices = lang_list,
              multiple = TRUE)
})

##| Owner
output$repo_top_owner <- renderUI({
  
  df2 <- getDataTopRepos()
  owner_list <- sort(unique(df2$owner))
  
  selectizeInput(inputId = "repo_top_owner",
                 label = h4("Owner:"),
                 choices = owner_list,
                 multiple = TRUE)
})

##| Owner
output$repo_top_repo <- renderUI({
  
  df2 <- getDataTopRepos()
  repo_list <- sort(unique(df2$repo_name))
  
  selectizeInput(inputId = "repo_top_repo",
                 label = h4("Repo:"),
                 choices = repo_list,
                 multiple = TRUE)
})

##| --------------------------------------------
##| Render Output Functions
##| --------------------------------------------


output$plot_repo_top <- renderChart2({    
  
  n <- createPlotRepoTop()  
  
})

output$table_repo_top <- renderDataTable({

  df3 <- filterRepoTop()
  df4 <- filter(df3, group != '')
  df4 <- arrange(df4, desc(stars))    

  df4$rank <- as.numeric(rownames(df4))
  df4$link_homepage <- ifelse(df4$homepage == '', '', createButtonLink(df4$homepage, 'Homepage'))
  df4$link_repo <- ifelse(df4$url == '', '', createButtonLink(df4$url, 'Repo'))
  
  df5 <- select(df4, rank, repo_name, owner, language, 
                stars, age_days, stars_per_week, 
                forks, date_created_str,
                link_homepage, link_repo)

  colnames(df5) <- c('Rank', 'Repo Name', 'Owner', 'Language', 'Stars', 
    'Age[Days]', 'Stars/Week', 'Forks','Date Created','Homepage', 'Repo')
  
  return(df5)

}, options = list(scrollX=TRUE), escape=FALSE) 

