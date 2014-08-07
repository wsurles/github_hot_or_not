helpfiles <- list.files(".", pattern = "*.md")
for(hf in helpfiles) {
	knit2html(hf, options = "", stylesheet = "empty.css")
	markdownToHTML(inputfile, outputfile, options = c(""), stylesheet='empty.css')  
}