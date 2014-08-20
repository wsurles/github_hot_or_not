
##| --------------------------------------------
##| Crunch Data Functions
##| --------------------------------------------


crunchDataLanguage <- function(df) {
  
  df2 <- df %>%
    group_by(language) %>%
    summarize(
      stars = sum(stars),
      repos = length(name),
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

# chooseLang <- reactive({
# 
#   ## This makes the chart wait until the input is loaded
#   choice_lang <- ifelse(is.null(input$lang), 'R', input$lang)
#   
#   switch(choice_lang,
#         JavaScript = load('data/repos_javascript.RData'),
#         Python = load('data/repos_python.RData'),
#         R = load('data/repos_R.RData')
#         )
# 
#   return(df)
# 
#   })
# 
# chooseBreaks <- reactive({
# 
#   ## This makes the chart wait until the input is loaded
#   choice_lang <- ifelse(is.null(input$lang), 'R', input$lang)
#   
#   if (choice_lang == 'JavaScript') {
#     
#     breakpoints <- c(0, 5.5, 10.5, 15.5, 10000)
#     labels <- c("5-0", "10-6", "15-11","16+")
#   
#   } else if (choice_lang == 'Python') {
#   
#     breakpoints <- c(0, 1.5, 3.5, 6.5, 10000)
#     labels <- c("1-0", "3-1", "6-3","6+")    
#   
#   } else {
#   
#     breakpoints <- c(0, .15, .45, 1, 10000)
#     labels <- c(".1-0", ".4-.2", "1-.5","1+")
#   
#   }
# 
#   return(list(breakpoints, labels))
# 
# })

# crunchDataGithub <- function(df) {
# 
#   result <- chooseBreaks()
#   breakpoints <- result[[1]]
#   labels <- result[[2]]
#   
#   df <- unique(df)
#   df <- df[1:100,]
# 
#   df2 <- df %>%
#     mutate(
#       date_created = as.Date(created_at),
#       date_created_str = as.character(date_created),
#       age_days = as.numeric(today() - date_created),
#       
#       watch_per_day = round(watchers/age_days, 1),
#       
#       log_forks = log10(forks),
#       log_forks = ifelse(is.finite(log_forks) == F, 0, log_forks),
#       
#       watch_group = cut(watch_per_day, breaks = breakpoints, include.lowest = T, right = T, label = labels, ordered = T), 
#       watch_group = ordered(watch_group, levels = c(labels, '')),
# 
#       homepage = ifelse(is.na(homepage),'', homepage)
#     ) %>%
#     arrange(desc(watch_group))
# 
#   return(df2)
# 
# }
# 

filterLanguage <- reactive({
  ##| Fitler on Language
  ##| - Change the -group- for all points that do not match filter selection
  ##| - This allows all points to be plotted and maintain context
  ##| - '' group will be plotted in a light color
  ##| - Rearrange after changing group to maintain color order
    
  df3 <- crunchDataLanguage(df)
  # input <- data.frame(lang_language = 'CSS')
  
  ## Filter dots 
  if (is.null(input$lang_language) == F ) {
    df3$group[!(df3$language %in% input$lang_language) ] <- ''
  }
  
  df3 <- arrange(df3, group)
  
  return(df3)
  
})


setColorLanguage <- function(df2, df3) {

  color_list <- c('whitesmoke','orangered', 'orange', 'steelblue', 'forestgreen')

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

  p <- nPlot(log_stars ~ log_repos, group = 'group', data = df3, type = 'scatterChart')
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
  
  lang_list <- sort(unique(df$language))
  
  selectizeInput(inputId = "lang_language",
              label = h4("Language:"),
              choices = lang_list,
              multiple = TRUE)
})

# ##| Owner
# output$repo_owner <- renderUI({
#   
#   df <- chooseLang()
#   df2 <- crunchDataGithub(df)
#   owner_list <- sort(unique(df2$owner))
#   
#   selectizeInput(inputId = "owner",
#                  label = h4("Owner:"),
#                  choices = owner_list,
#                  multiple = TRUE)
# })

##| --------------------------------------------
##| Render Output Functions
##| --------------------------------------------


output$plot_language <- renderChart2({    
  
  df2 <- crunchDataLanguage(df)
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

