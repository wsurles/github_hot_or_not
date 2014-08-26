
##| --------------------------------------------
##| Crunch Data Functions
##| --------------------------------------------

crunchDataRepoTopLang <- reactive({
  
  # choice_lang <- 'R'
  choice_lang <- if (is.null(input$repo_top_language_lang)) 'JavaScript' else input$repo_top_language_lang
  
  df <- df_repos
  
  ## Initial crunch
  df2 <- df %>%
    filter(language == choice_lang) %>%
    mutate(
      date_created = as.Date(created_at),
      date_created_str = as.character(date_created),
      age_days = as.numeric(today() - date_created),
      
      stars_per_week = round(stars/age_days*7, 3),
      
      log_stars = log10(stars),
      log_forks = log10(forks),
      
      log_stars = ifelse(is.finite(log_stars) == F, 0, log_stars),
      log_forks = ifelse(is.finite(log_forks) == F, 0, log_forks)
    ) %>%
    arrange(desc(stars))
  
  df2 <- df2[1:min(100, dim(df2)[1]),]
  
#   str(df2)
  
  ##| Set breakpoints and labels

  if (dim(df2)[1] >= 10) {
    
    breakpoints <- ceiling(quantile(df2$stars_per_week))
    breakpoints[1] <- 0
    breakpoints <- sprintf("%02d", breakpoints)
    
    if (all(!duplicated(breakpoints))==F) {
      breakpoints <- round(quantile(df2$stars_per_week),3)
      breakpoints[1] <- 0
      breakpoints <- sprintf("%02.3f", breakpoints)
    }
    
    labels <- character()
    for (i in 1:(length(breakpoints) - 1)) {
      labels[i] <- paste0(sprintf("%02s", breakpoints[i]), "-", sprintf("%02s", breakpoints[i+1]))
    }
    
  } else {
    breakpoints <- c(0, max(df2$stars_per_week))
    labels <- paste0(sprintf("%02s", breakpoints[1]), "-", sprintf("%02s", breakpoints[2]))
  }
    
  ## Add groups and arrange
  df2 <- df2 %>%
    mutate(
      group = cut(stars_per_week, 
                  breaks = breakpoints, 
                  label = labels, 
                  include.lowest = T, 
                  right = T, 
                  ordered = T),
      group = ordered(group, levels = c('',labels))
    ) %>%
    arrange(group)
  
  return(df2)

})

filterRepoTopLang <- reactive({
  ##| Fitler on Owner
  ##| - Change the -group- for all subs that do not match owner list
  ##| - This allows all subs to be plotted and maintain context
  ##| - '' group will be plotted in a light color
  ##| - Rearrange after changing group to maintain color order
  
  df3 <- crunchDataRepoTopLang()
  # df3 <- df2  
  #  input <- data.frame(repo_top_language = 'Matlab')
  
  ## Filter dots 
  if (is.null(input$repo_top_owner_lang) == F |
      is.null(input$repo_top_repo_lang) == F ) {
        df3$group[ 
          !(df3$owner %in% input$repo_top_owner_lang) &
          !(df3$repo_name %in% input$repo_top_repo_lang)] <- ''
  }
  
  df3 <- arrange(df3, group)
  
  return(df3)
                
})


setColorRepoTopLang <- function(df2, df3) {

  color_list <- c('whitesmoke', 'orangered', 'orange', 'steelblue', 'forestgreen')

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

createPlotRepoTopLang <- function(df3, color) {
  
  df4 <- select(df3, stars, log_stars, age_days, group, log_forks, 
                repo_name, language, stars_per_week, 
                forks, date_created_str)
  
  p2 <- nPlot(log_stars ~ age_days, group = 'group', data = df4, type = 'scatterChart')
  p2$yAxis(axisLabel = 'Stars')
  p2$xAxis(axisLabel = 'Age in Days')
  p2$chart(color = color)
  p2$chart(size = '#! function(d){return d.log_forks} !#')
  p2$yAxis(tickFormat="#! function(d) {return Math.round(Math.pow(10, d));}!#")
  p2$chart(tooltipContent = "#!
          function(key, x, y, d){ 
            return '<h3>' + d.point.repo_name + '</h3>' +
            '<p> <b>' + d.point.language + ' </b> </p>' +
            '<p>' + '<b>' +  d.point.stars_per_week + ' Stars/Week' + '</b>' +'</p>' +
            '<p> Age in Days = ' +  d.point.age_days + '</p>' +                    
            '<p> Stars = ' +  d.point.stars + '</p>' +          
            '<p> Forks = ' +  d.point.forks + '</p>' +       
            '<p> Date Created = ' +  d.point.date_created_str + '</p>'
          }
          !#")
  p2
  
  return(p2)
  
}

##| --------------------------------------------
##| Render UI Functions
##| --------------------------------------------

##| Language
output$repo_top_language_lang <- renderUI({
  
  lang_list <- sort(unique(df_repos$language))
  
  selectizeInput(inputId = "repo_top_language_lang",
              label = h4("Language:"),
              choices = lang_list,
              selected = 'JavaScript')
})

##| Owner
output$repo_top_owner_lang <- renderUI({
  
  df2 <- crunchDataRepoTopLang()
  owner_list <- sort(unique(df2$owner))
  
  selectizeInput(inputId = "repo_top_owner_lang",
                 label = h4("Owner:"),
                 choices = owner_list,
                 multiple = TRUE)
})

##| Owner
output$repo_top_repo_lang <- renderUI({
  
  df2 <- crunchDataRepoTopLang()
  repo_list <- sort(unique(df2$repo_name))
  
  selectizeInput(inputId = "repo_top_repo_lang",
                 label = h4("Repo:"),
                 choices = repo_list,
                 multiple = TRUE)
})

##| --------------------------------------------
##| Render Output Functions
##| --------------------------------------------


output$plot_repo_top_lang <- renderChart2({    
  
  df2 <- crunchDataRepoTopLang()
  df3 <- filterRepoTopLang()
  color <- setColorRepoTopLang(df2,df3)
  n <- createPlotRepoTopLang(df3, color)  
  
})

output$table_repo_top_lang <- renderDataTable({

  df3 <- filterRepoTopLang()
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

}) 

