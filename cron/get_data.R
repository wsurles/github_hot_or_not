
library(bigrquery)

##|-----------------------------------------
##| Get github data from google big query
##|-----------------------------------------

##| NOTE: This is not a real billing number. 
billing_project <- "123456789" # put your project number here

##| R
sql <- paste(readLines("lib/query_repos_R_top_watchers.sql", warn=F), collapse="\n")
df <- query_exec("publicdata", "samples", sql, billing = billing_project)
save(df, file = 'data/repos_R.RData')

##| JavaScript
sql <- paste(readLines("lib/query_repos_javascript_top_watchers.sql", warn=F), collapse="\n")
df <- query_exec("publicdata", "samples", sql, billing = billing_project)
save(df, file = 'data/repos_javascript.RData')

##| Python
sql <- paste(readLines("lib/query_repos_python_top_watchers.sql", warn=F), collapse="\n")
df <- query_exec("publicdata", "samples", sql, billing = billing_project)
save(df, file = 'data/repos_python.RData')

##| TODO:
##| I should make the queries dynamic and put them in a loop. They are all the same.
##| I can do an initial query to get the top 20 or so languages. 
##| Put this code on a server so I can set up the cron. 
##| Set this up on a cron job to run once a week. 