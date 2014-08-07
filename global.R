library(dplyr)
library(rCharts)
library(bigrquery)
library(lubridate)
library(knitr)
library(markdown)

##| Create a button link for referencing external urls. 
##| - Its compactly and pretty and looks good in a table
createButtonLink <- function(link, text) {
  sprintf('
      <a class="mcnButton" 
      href="%s" 
      target="_blank" 
      style="font-weight: normal;
             background-color: #337EC6;
             border-radius: 5px;
             border: 6px solid #337EC6;
             cursor: pointer;
             letter-spacing: -0.5px;
             text-align: center;
             text-decoration: none;
             color: #FFFFFF;
             word-wrap: break-word !important; 
             font-family:Arial;"
             >%s</button>
             ',link, text)
}

##| Email button so I can get some feedback from users
emailButton <- function(title, link) {
  html <- sprintf("<a href='%s'  class='btn btn-success btn-lg'>%s</a>", link, title)
  Encoding(html) <- 'UTF-8'
  HTML(html)
}

##|-----------------------------------------
##| These are copied and modified from Radiant
##| https://github.com/mostly-harmless/radiant
##| http://vnijs.rady.ucsd.edu:3838/marketing/
##|-----------------------------------------

# Adding the figures path to avoid making a copy of all figures in www/figures
addResourcePath("figures", "help/figures/")

##| Binding to a bootstrap modal
helpModal <- function(title, link, content) {
  html <- sprintf("<div id='%s' class='modal hide fade in' style='display: none; '>
                     <div class='modal-header'><a class='close' data-dismiss='modal' href='#'>&times;</a>
                       <h3>%s</h3>
                     </div>
                     <div class='modal-body'>%s</div>
                   </div>
                   <button type='button' data-toggle='modal' href='#%s' class='btn btn-primary btn-lg'>%s</button>", link, title, content, link, title)
  Encoding(html) <- 'UTF-8'
  HTML(html)
}

inclMD <- function(file) return(markdownToHTML(file, options = c(""), stylesheet="www/empty.css"))

