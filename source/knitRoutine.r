library(knitr)

## Settings
setwd("/Users/russellshepherd/Dados Formosa/econproject/site/build")

# Our function for knitting Rhtml files.
Knit.2.web <- function(src, dest) {
  if( require("knitr")) {
      setwd("/Users/russellshepherd/Dados Formosa/econproject/site/build")
      ## This setion disabled because hooks are reset to default when knit is called.
      ## Any files with hide/show code toggels must have this hook set at the top:
    
      ## knit_hooks$set(toggle = function(before, options, envir) {
      ##  if (before) {
      ##    ##before after a chunk has been evaluated
      ##    return("<div class=\"codetoggle\"><a href=\"\">View Code</a></div>")
      ##  }
      ##})
    opts_knit$set(root.dir = "/Users/russellshepherd/Dados Formosa/econproject/site/build")
    src <- paste0("../../source/",src, collapse = NULL)
    dest <- paste0("../pages/",dest, collapse = NULL)
    knit(src,dest)
  }
  else {
    return("knitr not found.")
  }
}

## To call the function, do something like this:
Knit.2.web("3-Methods.Rhtml","3-Methods.html")

## To do all Rhtml files in a folder, use this:

##rhtml.files <- list.files(path="../../source/",pattern="\\.Rhtml$")
#for (x in 1:length(rhtml.files)) {
#  html.file <- paste0(substr(rhtml.files[x], 1, nchar(rhtml.files[x])-6),".html", collapse = NULL)
#  knit.2.web(rhhtml.files[x],html.file)
#}