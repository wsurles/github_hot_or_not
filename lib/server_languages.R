
##| --------------------------------------------
##| Crunch Data Functions
##| --------------------------------------------

getDataLang <- reactive({
  load('data/df_lang.RData')
  df2 <- df_lang
    
  return(df2)
})

filterLanguage <- reactive({
  ##| Fitler on Language
  ##| - Change the -group- for all points that do not match filter selection
  ##| - This allows all points to be plotted and maintain context
  ##| - '' group will be plotted in a light color
  ##| - Rearrange after changing group to maintain color order
    
  df3 <- getDataLang()
  # input <- data.frame(lang_language = 'CSS')
  
  ## Filter dots 
  if (is.null(input$lang_language) == F ) {
    df3$group[!(df3$language %in% input$lang_language) ] <- ''
  }
  
  df3 <- arrange(df3, group)
  
  return(df3)
  
})

setColorLanguage <- function(df2, df3) {

  color_list <- c('#E5E5E5', 'steelblue','forestgreen', 'orange', 'orangered')

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

createPlotLanguage <- reactive({
  
  df2 <- getDataLang()
  df3 <- filterLanguage()
  color <- setColorLanguage(df2,df3)
  
  df4 <- select(df3, log_stars, log_repos, group, log_forks, language, stars_per_repo,
    stars, repos, forks, hottness)
  
  p <- nPlot(hottness ~ log_repos, group = 'group', data = df4, type = 'scatterChart')
  p$yAxis(axisLabel = 'Hottness')
  p$xAxis(axisLabel = 'Repos')
  p$chart(size = '#! function(d){return d.log_forks} !#')
  p$xAxis(tickFormat="#! function(d) {return Math.round(Math.pow(10, d));}!#")
  # p$yAxis(tickFormat="#! function(d) {return Math.round(Math.pow(10, d));}!#")
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
  
  if (v$update_list_lang <= 0) {v$update_list_lang <- v$update_list_lang + 1}
  
  return(p)

})

##| --------------------------------------------
##| Render UI Functions
##| --------------------------------------------

##| Language
output$lang_language <- renderUI({
  
  selectizeInput(inputId = "lang_language",
              label = h4("Language:"),
              choices = NULL,
              multiple = TRUE)
})

observeEvent(v$update_list_lang, {

  df_lang <- getDataLang()
  list_lang <- sort(unique(df_lang$language))
  
  updateSelectInput(
    session, 
    inputId = 'lang_language',
    choices = list_lang
  )
})

##| --------------------------------------------
##| Render Output Functions
##| --------------------------------------------

output$plot_language <- renderChart2({    
  
  n <- createPlotLanguage()  
  
})

output$table_language <- renderDataTable({

  df3 <- filterLanguage()
  df4 <- filter(df3, group != '')
  df4 <- arrange(df4, desc(repos))    
  df4$rank <- as.numeric(rownames(df4))
  
  df5 <- select(df4, rank, language, repos, stars, stars_per_repo)

  colnames(df5) <- c('Rank', 'Language', 'Repos', 'Stars', 'Stars/Repo')
  
  return(df5)

}, options = list(scrollX=TRUE), escape=FALSE) 

