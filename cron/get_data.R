
library(bigrquery)

##|-----------------------------------------
##| Get github data from google big query
##|-----------------------------------------

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
