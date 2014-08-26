
##| --------------------------------------------
##| Crunch Data Functions
##| --------------------------------------------

crunchDataLanguage <- function(df_repos) {
  
#   df <- unique(df_repos)
  df <- df_repos

  df2 <- df %>%
    group_by(language) %>%
    summarize(
      stars = sum(stars),
      repos = length(repo_name),
      forks = sum(forks)
    ) %>%
    filter(!(is.na(language))) %>%
    mutate(
      
      log_stars = log10(stars),
      log_repos = log10(repos),
      log_forks = log10(forks),
      
      log_stars = ifelse(is.finite(log_stars) == F, 0, log_stars),
      log_repos = ifelse(is.finite(log_repos) == F, 0, log_repos),
      log_forks = ifelse(is.finite(log_forks) == F, 0, log_forks),
      
      stars_per_repo = round(stars/repos, 1)
    )
  
  ##| Set breakpoints and labels
  breakpoints <- sprintf("%02d", round(quantile(df2$stars_per_repo)))
  
  labels <- character()
  for (i in 1:(length(breakpoints) - 1)) {
    labels[i] <- paste0(sprintf("%02s", breakpoints[i]), "-", sprintf("%02s", breakpoints[i+1]))
  }

  ## Add groups and arrange
  df2 <- df2 %>%
    mutate(
      group = cut(stars_per_repo, 
         breaks = breakpoints, 
         label = labels, 
         include.lowest = T, 
         right = T, 
         ordered = T),
      group = ordered(group, levels = c('',labels))
    ) %>%
    arrange(group)
    
  return(df2)
}

filterLanguage <- reactive({
  ##| Fitler on Language
  ##| - Change the -group- for all points that do not match filter selection
  ##| - This allows all points to be plotted and maintain context
  ##| - '' group will be plotted in a light color
  ##| - Rearrange after changing group to maintain color order
    
  df3 <- crunchDataLanguage(df_repos)
  # input <- data.frame(lang_language = 'CSS')
  
  ## Filter dots 
  if (is.null(input$lang_language) == F ) {
    df3$group[!(df3$language %in% input$lang_language) ] <- ''
  }
  
  df3 <- arrange(df3, group)
  
  return(df3)
  
})

setColorLanguage <- function(df2, df3) {

  color_list <- c('whitesmoke', 'steelblue','forestgreen', 'orange', 'orangered')

  groups <- unique(levels(df2$group))

  tmp <- as.data.frame(table(df3$group))
  tmp$Var1 <- as.character(tmp$Var1)
  groups_filtered <-  filter(tmp, Freq > 0)

  color <- color_list[groups %in% groups_filtered$Var1]
  color <- color
  
  return(color)

}

##| --------------------------------------------
##| Plot Functions
##| --------------------------------------------

createPlotLanguage <- function(df3, color) {

  df4 <- select(df3, log_stars, log_repos, group, log_forks, language, stars_per_repo,
    stars, repos, forks)
  
  p <- nPlot(log_stars ~ log_repos, group = 'group', data = df4, type = 'scatterChart')
  p$yAxis(axisLabel = 'Stars')
  p$xAxis(axisLabel = 'Repos')
  p$chart(size = '#! function(d){return d.log_forks} !#')
  p$xAxis(tickFormat="#! function(d) {return Math.round(Math.pow(10, d));}!#")
  p$yAxis(tickFormat="#! function(d) {return Math.round(Math.pow(10, d));}!#")
  p$chart(color = color)
  p$chart(tooltipContent = "#!
          function(key, x, y, d){ 
            return '<h3>' + d.point.language + '</h3>' +
            '<p>' + '<b>' +  d.point.stars_per_repo + ' Stars/Repo' + '</b>' +'</p>' +                 
            '<p> Stars = ' +  d.point.stars + '</p>' +  
            '<p> Repos = ' +  d.point.repos + '</p>' +
            '<p> Forks = ' +  d.point.forks + '</p>'
          }
          !#")
  
return(p)

}

##| --------------------------------------------
##| Render UI Functions
##| --------------------------------------------

##| Language
output$lang_language <- renderUI({
  
  lang_list <- sort(unique(df_repos$language))
  
  selectizeInput(inputId = "lang_language",
              label = h4("Language:"),
              choices = lang_list,
              multiple = TRUE)
})

##| --------------------------------------------
##| Render Output Functions
##| --------------------------------------------

output$plot_language <- renderChart2({    
  
  df2 <- crunchDataLanguage(df_repos)
  df3 <- filterLanguage()
  color <- setColorLanguage(df2,df3)
  n <- createPlotLanguage(df3, color)  
  
})

output$table_language <- renderDataTable({

  df3 <- filterLanguage()
  df4 <- filter(df3, group != '')
  df4 <- arrange(df4, desc(repos))    
  df4$rank <- as.numeric(rownames(df4))
  
  df5 <- select(df4, rank, language, repos, stars, stars_per_repo)

  colnames(df5) <- c('Rank', 'Language', 'Repos', 'Stars', 'Stars/Repo')
  
  return(df5)

}) 

