# Github Hot or Not

This is a Shiny app to analyze what github repos are hot.  
It looks at the top 100 starred repos by language and allows you to drill down to the repo and homepage.

This is intended as a demo of Shiny and rCharts functionality that I find useful. 
 - A great NVD3 scatter chart made with rCharts
 - Fitlers that affect the chart and table
 - Tooltips
 - Links for drilling down
 - Help modal
 - Feedback email button
 - Much more

The App is here  
http://surlyanalytics.shinyapps.io/github_hot_or_not/

My presentation on the topic is here.  
Creating an Approachable Data Product with R using Shiny and rCharts  
http://wsurles.github.io/creating_an_approachable_data_product_with_R/  

I used google big query to get the github data. I provided it here in `/data`.   
You can see how I got the data in `/cron/get_data.R`.  
This data is not being actively updated with the cron script.  
The queries are in `/lib`.  
  
Please help me make this app better!

