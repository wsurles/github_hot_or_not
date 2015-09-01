##|-----------------------------------------
##| Initilize
##|-----------------------------------------

library(bigrquery)
source("creds/creds_bigquery.R")

##|-----------------------------------------
##| Crunch Data Functions
##|-----------------------------------------

crunchDataLanguage <- function(df_repos) {
  
  df2 <- df_repos %>%
    group_by(language) %>%
    summarize(
      stars = sum(stars),
      repos = n(),
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
      stars_per_repo = stars/repos,
      hottness = stars_per_repo * log_repos
    )
  
  ##| Set breakpoints and labels
  # breakpoints <- sprintf("%02d", round(quantile(df2$stars_per_repo, na.rm=T)))
  breakpoints <- sprintf("%02d", round(quantile(df2$hottness, na.rm=T)))
  
  labels <- character()
  for (i in 1:(length(breakpoints) - 1)) {
    labels[i] <- paste0(sprintf("%02s", breakpoints[i]), "-", sprintf("%02s", breakpoints[i+1]))
  }
  
  ## Add groups and arrange
  df2 <- df2 %>%
    mutate(
      group = cut(hottness, 
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

crunchDataTopRepos <- function(df_repos) {
  
  df2 <- df_repos[1:500,]
  
  ## Initial crunch
  df2 <- df2 %>%
    mutate(
      date_created = as.Date(created_at),
      date_created_str = as.character(date_created),
      age_days = as.numeric(today() - date_created),
      
      stars_per_week = round(stars/age_days*7, 1),
      
      log_stars = log10(stars),
      log_forks = log10(forks),
      
      log_stars = ifelse(is.finite(log_stars) == F, 0, log_stars),
      log_forks = ifelse(is.finite(log_forks) == F, 0, log_forks)
    )
  
  ##| Set breakpoints and labels
  breakpoints <- ceiling(quantile(df2$stars_per_week))
  breakpoints[1] <- 0
  breakpoints <- sprintf("%02d", breakpoints)
  
  labels <- character()
  for (i in 1:(length(breakpoints) - 1)) {
    labels[i] <- paste0(sprintf("%02s", breakpoints[i]), "-", sprintf("%02s", breakpoints[i+1]))
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
  
}


crunchDataTopReposByLang <- function(df_repos) {
  
  df2 <- df_repos %>%
    filter(stars > 1) %>%
    group_by(language) %>%
    top_n(100, stars) %>%
    mutate(
      date_created = as.Date(created_at),
      date_created_str = as.character(date_created),
      age_days = as.numeric(today() - date_created),
      
      stars_per_week = round(stars/age_days*7, 3),
      
      log_stars = log10(stars),
      log_forks = log10(forks),
      
      log_stars = ifelse(is.finite(log_stars) == F, 0, log_stars),
      log_forks = ifelse(is.finite(log_forks) == F, 0, log_forks)
    )
  
  return(df2)
  
}


##|--------------------------------
##| Get and Save Data
##|--------------------------------

sql <- paste(readLines("lib/query_repos.sql", warn=F), collapse="\n")
df_repos <- query_exec(sql, project = Sys.getenv("project_id"), max_pages = Inf)
# save(df_repos, file = 'data/repos.RData')

df_lang <- crunchDataLanguage(df_repos)
save(df_lang, file='data/df_lang.RData')

df_top_repos <- crunchDataTopRepos(df_repos)
save(df_top_repos, file='data/df_top_repos.RData')

df_top_repos_by_lang <- crunchDataTopReposByLang(df_repos)
save(df_top_repos_by_lang, file='data/df_top_repos_by_lang.RData')
    
##|--------------------------------
##| Get Contributors to top 100 repos per language
##|--------------------------------

## Get the top 100 repos per language
langs <- unique(df_repos$language)
repos <- NULL
df <- unique(df_repos)

for (i in 1:length(langs)) {
  
  df2 <- df %>%
    filter(language == langs[i]) %>%
    arrange(desc(stars))
  
  df2 <- df2[1:min(100, dim(df2)[1]),]
  
  repos <- c(repos, df2$repo_name)

}

save(repos, file = 'data/repos_list.RData')

## Make a string of all repos
repos_str <- paste(repos, collapse = "','")

## Create the query with a token to be replaced
query <- "SELECT 
  gt.repository_language as language
  ,gt.repository_name as repo_name
  ,gt.actor as actor
  ,actor_attributes_name
  ,events
  ,actor_attributes_gravatar_id
  ,actor_attributes_company
  ,actor_attributes_location
  ,actor_attributes_blog
  ,gt.created_at as created_at
  FROM [githubarchive:github.timeline] gt
  INNER JOIN EACH(
    SELECT 
    actor
    ,COUNT(type) as events
    ,MAX(created_at) AS created_at
    FROM [githubarchive:github.timeline] 
    WHERE type in ('PushEvent', 'CreateEvent') 
    AND repository_name IN ('%repos%')
    GROUP BY actor
    ORDER BY events DESC
  ) actor_events
  ON actor_events.actor = gt.actor
  AND actor_events.created_at = gt.created_at
  WHERE type in ('PushEvent', 'CreateEvent') 
  ORDER BY events desc"
  
## Put the repo string in place of the token
sql <- gsub("%repos%", repos_str, query)

## Run the query to get the contributors
df_actors <- query_exec("publicdata", "samples", sql, billing = billing_project, max_pages = Inf)
save(df_actors, file = 'data/actors.RData')

