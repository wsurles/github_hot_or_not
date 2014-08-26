##|-----------------------------------------
##| Get github data from google big query
##|-----------------------------------------

# setwd("~/Dev/non_work_projects/github_hot_or_not")
library(bigrquery)
source("creds/creds_bigquery.R")

##| Repos
sql <- paste(readLines("lib/query_repos.sql", warn=F), collapse="\n")
df_repos <- query_exec("publicdata", "samples", sql, billing = billing_project, max_pages = Inf)
save(df_repos, file = 'data/repos.RData')

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

