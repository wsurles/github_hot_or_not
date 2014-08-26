
##| --------------------------------------------
##| Crunch Data Functions
##| --------------------------------------------

tmp1 <- df_actors[colnames(df_actors) != 'language']
# tmp1 <- select(df_actors, -language)
tmp2 <- select(df_repos, language, repo_name)
df <- left_join(tmp1, tmp2, by = 'repo_name')

filterActorLang <- reactive({
  
  ## Filter language
  ## choice_lang <- 'JavaScript'
  choice_lang <- ifelse(is.null(input$actor_lang), 'JavaScript', input$actor_lang)
  df <- filter(df, language == choice_lang)
  
  return(df)

})

filterActor <- function(df) {
  
  ## filter repo and actor
  df$group <- 'in'
  
  if (  is.null(input$actor_repo_lang) == F  | 
        is.null(input$actor_actor_lang) == F) {
    df$group[ 
        !(df$repo_name %in% input$actor_repo_lang) & 
        !(df$actor %in% input$actor_actor_lang)] <- 'out'
  }
  
  df2 <- df %>%
    filter(group == 'in')
  
  return(df2)
  
}

crunchDataActor <- function(df2) {
  
  df3 <- df2 %>%
    group_by(actor) %>%
    summarize(
      repos = length(repo_name),
      events = sum(events)
    ) %>%
    arrange(desc(events))
  
  df3 <- df3[1:min(50, dim(df3)[1]),]
  
  return(df3)

}

##| --------------------------------------------
##| Plot Functions
##| --------------------------------------------

createPlotActor<- function(df) {
  
  h <- dim(df)[1] * 20 + 100
  p <- nPlot(events ~ actor, data = df, type = 'multiBarHorizontalChart', height=h, width=800)
  p$chart(margin = list(top = 100,right = 20,bottom = 50,left = 180))
  p$chart(showControls = F)

  return(p)
  
}

##| --------------------------------------------
##| Render UI Functions
##| --------------------------------------------

##| Language
output$actor_lang <- renderUI({
  
  lang_list <- sort(unique(df_repos$language))
  
  selectizeInput(inputId = "actor_lang",
              label = h4("Language:"),
              choices = lang_list,
              selected = 'JavaScript')
})

##| Repo
output$actor_repo_lang <- renderUI({

  df <- filterActorLang()
  repo_list <- sort(unique(df$repo_name))
  
  selectizeInput(inputId = "actor_repo_lang",
                 label = h4("Repo:"),
                 choices = repo_list,
                 multiple = TRUE)
})

##| Actor
output$actor_actor_lang <- renderUI({
  
  df <- filterActorLang()
  df <- df[1:min(100, dim(df)[1]),]
  actor_list <- sort(unique(df$actor))
  
  selectizeInput(inputId = "actor_actor_lang",
                 label = h4("Contributor:"),
                 choices = actor_list,
                 multiple = TRUE)
})

##| --------------------------------------------
##| Render Output Functions
##| --------------------------------------------


output$plot_actor_lang <- renderChart2({    
  
  df <- filterActorLang()
  df2 <- filterActor(df)
  df3 <- crunchDataActor(df2)
  n <- createPlotActor(df3)  
  
})

output$table_actor_lang <- renderDataTable({
  
  df <- filterActorLang()
  df <- filterActor(df)
  
  df[is.na(df)] <- ''
  
  ## Only include the top 1000 for the table or it will take forever
  df <- df[1:min(100, dim(df)[1]),]
  
  df$gravatar <- ifelse(df$actor_attributes_gravatar_id == '', '', createGravatarImage(df$actor_attributes_gravatar_id))
  df$link_blog <- ifelse(df$actor_attributes_blog == '', '', createButtonLink(df$actor_attributes_blog, 'Blog'))
  df$link_github_user <- ifelse(df$actor == '', '', createButtonLink(paste0('https://github.com/',df$actor), 'Github'))
  
  df5 <- select(df, gravatar, actor, actor_attributes_name, repo_name, 
                events, actor_attributes_company,
                actor_attributes_location, link_github_user, link_blog)

  colnames(df5) <- c( 'Gravatar', 'Actor', 'Name', 'Repo', 
                     'Events',  'Company',
                     'Location', 'Github', 'Blog')
  
  return(df5)

}) 

