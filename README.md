# Github Hot or Not
This is a full implementation of a shiny app with lots of tricks to make it awesome

I used google big query to get the git hub data. I provided it here in `/data`. You can see how I got the data in `/cron/get_data.R`. The queries are in `/lib`.

## Simple Layout of ui and server
These reference other files that have the functions

server.R
```s
shinyServer(function(input, output, session) {

  ##| Source Files
  source('lib/ui_tabs.R', local = T)
  source('lib/server_github.R', local = T)
  
})

```

ui.R
```s
shinyUI(

  navbarPage(

    id = "nbp",
    title = "Data Hub", 
    theme = "bootstrap.css",
    collapsable = TRUE,
    footer = 'text',

    tabPanel("rCharts", value = "rcharts",
      
      includeHTML("www/data_hub_scripts.js"),
      includeHTML("www/get_font_awesome.html"),
      
      navlistPanel(
        
        id="nlp",
        widths=c(2,10),
        
        "Header",
        
        tabPanel("GitHub", value = "github", uiOutput("github")),
        tabPanel("Examples", value = "examples", uiOutput("examples"))
    
      )
    ),

    tabPanel("Tab 2", value = "tab2",
      
      navlistPanel(
        
        id="nlp",
        widths=c(2,10),
        
        "Header",
        
        tabPanel("Page 1", value = "page1", uiOutput('page1')),
        tabPanel("Page 2", value = "page2", uiOutput('page2'))
    
      )
    )
  )
)
```

- function layout 
- reactive functions
- organized folder structure
-- server and ui functions in lib
-- sql queries in lib


## Step 1: Get, crunch, and plot data
#### Process:
1. Load the libraries
1. Load the data from a csv file

```s
library(plyr)
print(p)
```
![](www/step_1.png?raw=true)

----
## Step 2: 


----
## Step 3: 


Go get the bootstrap file from bootswatch. Pick a theme you like. Downlad the file. Stick it in your `www` folder.
-- need reference --
Reference the `bootstrap.css` file as your `theme` under the `navbarPage` function.
```s
navbarPage(
  
    id = "nbp",
    title = "Data Hub", 
    theme = "bootstrap.css",
```

I added the code selectize.css to the bottom of this file. 
-- need reference --






