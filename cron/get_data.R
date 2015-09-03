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
save(df_repos, file = 'data/repos.RData')

df_lang <- crunchDataLanguage(df_repos)
save(df_lang, file='data/df_lang.RData')

df_top_repos <- crunchDataTopRepos(df_repos)
save(df_top_repos, file='data/df_top_repos.RData')

df_top_repos_by_lang <- crunchDataTopReposByLang(df_repos)
save(df_top_repos_by_lang, file='data/df_top_repos_by_lang.RData')
