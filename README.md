## Governance and Growth

This project is an example of generating [reproducible research](http://yihui.name/en/2012/06/enjoyable-reproducible-research/) for the web using [R](http://www.r-project.org). 

## Starting a new project

These instructions are based on [Barry Rowlingson's workflow for publishing course notes](http://geospaced.blogspot.tw/2012/05/knitr-cactus-twitterbootstrap-jquery.html). The process involves two steps:

1. Use knitr to turn annotated R code into webpages.
2. Use cactus.py to build a website by stitching those pages together with a template.

#### Annotated R scripts

Create a project directory with the following sub-directories. Using this directory tree saves you the time of correcting broken image links to graphs ouput from R later on.

    - data				Data files to be used by R
    - site				Where cactus will house and build the project website  
    - source          All your .Rhtml files

Using R Studio with knitr, write your annotated R code using the .Rhtml format. Instead of wrapping the document in the normal html tags, set Django hooks at the top and bottom:

```r
{% extends "base.html" %}{% block content %}

Lorem ipsum dolor sit amet...

<!--begin.rcode block1
## Generate some numbers
x <- sample(1:20,10)
end.rcode-->

{% endblock %}
```

If you want to include a show/hide code function, you can tell knitr to add a CSS layer which acts as show/hide toggle button by setting the following knitr chunk hook before the Django hook at the top of each .Rhtml file. (*This is a workaround, you should be able to set the chunk hook once before calling* `knit()`).

```r
<!--begin.rcode echo=FALSE

knit_hooks$set(toggle = function(before, options, envir) {
  if (before) {
    ## before a chunk has been evaluated.
    return("<div class=\"codetoggle\"><a href=\"\">[+/- Code]</a></div>")
    }
  })

end.rcode-->
```

#### Static Website Generator

Set up [cactus.py](https://github.com/koenbok/Cactus), follow the tutorial to create a new project in `projectdirectory/site/`. 

Get and customize an HTML template like Skeleton to use as the base.html template. Grab the CSS file used by knitr as a starting point to make the code chunks look nicer. If you want a show/hide code chunks function, remember to add necessary CSS styles.

If you set the knitr chunk hook to add a show/hide code button above all code chunks, add some JavsScript to `site/templates/base.html` to handle showing/hiding the code layers. For example (using jQuery):

```html
<!-- JavaScript Includes -->
<script type="text/javascript" src="../static/js/jQuery.js"></script>

<!-- show/hide code script -->
<script type="text/javascript">
	$('.codetoggle').click(function(e) {
	e.preventDefault();
	$(this).parent().children('.source').slideToggle("fast");
	})
	var originalText;
	$('.example-grid').children().hover(
	function() {
	originalText = $(this).text();
	$(this).html($(this).width()+'px');
	},
	function() {
	$(this).html(originalText);
	}) 
</script> <!-- show/hide code-->
```

#### Publishing and Updating

The following script is an exmaple of calling both knitr and catcus from R. Alternatively, this can also be implemented for single pages, e.g.: `Knit.2.cactus('3-Methods.Rhtml','3-Methods.html)`.

```R
projectdirectory <- "projectdirectory" 

pd <- paste0(projectdirectory, "/site/build", collapse = NULL)
setwd(pd)

## Function for calling knitr:
Knit.2.cactus <- function(src, dest) {
  if(require(knitr)) {
    opts_knit$set(root.dir = pd) 
    src <- paste0("../../source/",src, collapse = NULL)
    dest <- paste0("../pages/",dest, collapse = NULL)
    knit(src,dest)
  }
  else {
    return("knitr not found.")
  }
}

# Get a list of all the annotated R scripts
rhtml.files <- list.files(path="../../source/",pattern="\\.Rhtml$")

# Knit all .Rhtml files to .html
for (x in 1:length(rhtml.files)) {
	html.file <- paste0(substr(rhtml.files[x], 1, nchar(rhtml.files[x])-6),".html", collapse = NULL)
	Knit.2.cactus(rhhtml.files[x],html.file)
}

# System call tells cactus to rebuild the site
system(paste0("cactus.py ", pd, " build", collapse = NULL))
```
