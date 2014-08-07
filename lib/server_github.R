
##| --------------------------------------------
##| Crunch Data Functions
##| --------------------------------------------

chooseLang <- reactive({

  ## This makes the chart wait until the input is loaded
  choice_lang <- ifelse(is.null(input$lang), 'R', input$lang)
  
  switch(choice_lang,
        JavaScript = load('data/repos_javascript.RData'),
        Python = load('data/repos_python.RData'),
        R = load('data/repos_R.RData')
        )

  return(df)

  })

chooseBreaks <- reactive({

  ## This makes the chart wait until the input is loaded
  choice_lang <- ifelse(is.null(input$lang), 'R', input$lang)
  
  if (choice_lang == 'JavaScript') {
    
    breakpoints <- c(0, 5.5, 10.5, 15.5, 10000)
    labels <- c("5-0", "10-6", "15-11","16+")
  
  } else if (choice_lang == 'Python') {
  
    breakpoints <- c(0, 1.5, 3.5, 6.5, 10000)
    labels <- c("1-0", "3-1", "6-3","6+")    
  
  } else {
  
    breakpoints <- c(0, .15, .45, 1, 10000)
    labels <- c(".1-0", ".4-.2", "1-.5","1+")
  
  }

  return(list(breakpoints, labels))

})

crunchDataGithub <- function(df) {

  result <- chooseBreaks()
  breakpoints <- result[[1]]
  labels <- result[[2]]
  
  df <- unique(df)
  df <- df[1:100,]

  df2 <- df %>%
    mutate(
      date_created = as.Date(repository_created_at),
      date_created_str = as.character(date_created),
      age_days = as.numeric(today() - date_created),
      
      watch_per_day = round(repository_watchers/age_days, 1),
      
      log_forks = log10(repository_forks),
      log_forks = ifelse(is.finite(log_forks) == F, 0, log_forks),
      
      watch_group = cut(watch_per_day, breaks = breakpoints, include.lowest = T, right = T, label = labels, ordered = T), 
      watch_group = ordered(watch_group, levels = c(labels, '')),

      repository_homepage = ifelse(is.na(repository_homepage),'', repository_homepage)
    ) %>%
    arrange(desc(watch_group))

  return(df2)

}

filterGithub <- reactive({
  ##| Fitler on Owner
  ##| - Change the -group- for all subs that do not match owner list
  ##| - This allows all subs to be plotted and maintain context
  ##| - '' group will be plotted in a light color
  ##| - Rearrange after changing group to maintain color order
    
  df <- chooseLang()
  df2 <- crunchDataGithub(df)
      
  ## Filter dots 
  if (is.null(input$owner) == F ) {
    df2$watch_group[!(df2$repository_owner %in% input$owner) ] <- ''
  }
  
  df2 <- arrange(df2, desc(watch_group))
  
  return(df2)
                
})


setColorGithub <- function(df2, df3) {

  color_list <- c('orangered', 'orange', 'steelblue', 'forestgreen', 'whitesmoke')

  groups <- unique(levels(df2$watch_group))

  tmp <- as.data.frame(table(df3$watch_group))
  tmp$Var1 <- as.character(tmp$Var1)
  groups_filtered <-  filter(tmp, Freq > 0)

  color <- color_list[groups %in% groups_filtered$Var1]
  color <- rev(color)
  
  return(color)

}

##| --------------------------------------------
##| Plot Functions
##| --------------------------------------------

createPlotGithub <- function(df2, color) {

  df3 <- select(df2, repository_watchers, age_days, watch_group, log_forks, repository_name, watch_per_day, repository_owner, 
              repository_forks, date_created_str)

  p <- nPlot(repository_watchers ~ age_days, group = 'watch_group', data = df3, type = 'scatterChart')
  p$yAxis(axisLabel = 'Stars')
  p$xAxis(axisLabel = 'Age in Days')
  p$chart(color = color)
  p$chart(size = '#! function(d){return d.log_forks} !#')
  p$chart(tooltipContent = "#!
          function(key, x, y, d){ 
            return '<h3>' + d.point.repository_name + '</h3>' +
            '<p>' + '<b>' +  d.point.watch_per_day + ' Stars/Day' + '</b>' +'</p>' +
            '<p> Owner = ' +  d.point.repository_owner + '</p>' +
            '<p> Age in Days = ' +  d.point.age_days + '</p>' +                    
            '<p> Stars = ' +  d.point.repository_watchers + '</p>' +          
            '<p> Forks = ' +  d.point.repository_forks + '</p>' +       
            '<p> Date Created = ' +  d.point.date_created_str + '</p>'
          }
          !#")
  
  return(p)

}


##| --------------------------------------------
##| Render UI Functions
##| --------------------------------------------

##| Language
output$language <- renderUI({
  
  lang_list <- c('JavaScript','Python','R')
  
  selectizeInput(inputId = "lang",
              label = h4("Language:"),
              choices = lang_list,
              selected = 'R')
})

##| Owner
output$repo_owner <- renderUI({
  
  df <- chooseLang()
  df2 <- crunchDataGithub(df)
  owner_list <- sort(unique(df2$repository_owner))
  
  selectizeInput(inputId = "owner",
                 label = h4("Owner:"),
                 choices = owner_list,
                 multiple = TRUE)
})

##| --------------------------------------------
##| Render Output Functions
##| --------------------------------------------


output$plot_github <- renderChart2({    
  
  df <- chooseLang()
  df2 <- crunchDataGithub(df)
  df3 <- filterGithub()
  color <- setColorGithub(df2,df3)
  n <- createPlotGithub(df3, color)  
  
})

output$table_github <- renderDataTable({

  df <- chooseLang()
  df3 <- filterGithub()
  df4 <- filter(df3, watch_group != '')
  df4 <- arrange(df4, desc(repository_watchers))    
  df4$link_homepage <- ifelse(df4$repository_homepage == '', '', createButtonLink(df4$repository_homepage, 'Homepage'))
  df4$link_repo <- ifelse(df4$repository_url == '', '', createButtonLink(df4$repository_url, 'Repo'))
  # df4$link <- createButtonLink(df4$sf_id)
  
  df5 <- select(df4, repository_name, repository_owner, watch_per_day, 
    repository_watchers, age_days, repository_forks, 
    date_created_str, link_homepage, link_repo)

  colnames(df5) <- c('Repo name', 'Owner', 'Stars/Day', 
    'Stars', 'Age [days]', 'Forks', 
    'Date Created', 'Homepage', 'Repo')
  
  return(df5)

}) 

