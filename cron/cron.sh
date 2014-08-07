#/bin/sh
cd /srv/shiny-server/default/apps/app_github_hot
/usr/bin/R --vanilla --file=/srv/shiny-server/default/apps/app_github_hot/cron/get_data.R
