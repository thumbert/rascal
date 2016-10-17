## Work with the http://dygraphs.com js-library
##
## 
##


############################################################
## Create a dygraph object in R.
## @param div is the name of the html div, set to graphdiv
##   to match the htmlSkeleton. 
## @param data is a data.frame with data
## @param options is a list corresponding to the dygraph
##   options.
## @return a dygraph object
##
dygraph <- function(data,
                    options=list(),
                    div='graphdiv') {

  return(structure(list(div=div,
                        data=data,
                        options=options), class='dygraph'))
}

############################################################
## Create the html associated with this dygraph and save it
## to a file for viewing in a browser.
##
## Generate the minimal HTML needed to display this graph. 
## You should probably make it other ways.
##
makeHtml <- function(dygraph,
                     con='index.html') {

  aux1 <- '
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dygraphs from R</title>
    <script src="//cdnjs.cloudflare.com/ajax/libs/dygraph/1.1.1/dygraph-combined.js"></script>
</head>
<body>
<div id="graphdiv" style="width:1000px; height:500px;"></div>
<script type="text/javascript">'
  aux2 <- paste('\n  var data=', .jsConverterDataFrame(dygraph$data), sep='')
  aux3 <- ';
  new Dygraph(document.getElementById("graphdiv"), data);
</script>
<p>When you zoom and pan, the weekend regions remain highlighted.</p>
<p>Push the mouse down and highlight a region for zooming in.  Double-click to zoom back out.</p>
<p>See <a href="https://dygraphs.com/">dygraphs js</a></p>
</body>
</html>'

  writeLines(paste(aux1, aux2, aux3, sep=''), con=con)  
}

## Given a vector x of POSIXct datetimes, return a vector of JS Date strings 
.jsConverterPOSIXct <- function(x) {
    y <- as.POSIXlt(x)
    return(paste('new Date(', y$year+1900, ',', y$mon, ',', y$mday,
                 ',',y$hour, ',',y$min, ',',y$sec, ')', sep=''))
}

## Convert a data.frame to a JS array
.jsConverterDataFrame <- function(x)
{
   sep='' 
   y <- rep('[', length=nrow(x))
   for (i in 1:ncol(x)) {
     if (i>1) sep=','  
     if (inherits(x[[i]], 'POSIXct')) {
       y <- paste(y, .jsConverterPOSIXct(x[[i]]), sep=sep)
     } else {
       y <- paste(y, x[[i]], sep=sep)
     }
   }
   y <- paste(y, ']', sep='', collapse=',')

   paste('[', y, ']', sep='')  ## enclose everything into an array
}


.mockData <- function()
{
  N <- 365
  X <- matrix(rnorm(N*100), nrow=N)
  X <- apply(X, 2, cumsum)
  hours <- seq(as.POSIXct('2016-01-01'), length.out=N, by='1 day')

  data.frame(hour=hours, X)
}


############################################################
## 
## 
.test_dygraphs <- function()
{
  source('./lib_dygraphs.R')

  hours <- seq(as.POSIXct('2016-01-01'), length.out=10, by='1 hour')
  .jsConverterPOSIXct(hours)

  df <- data.frame(hour=hours, value=1:10)
  .jsConverterDataFrame(df)

  graph <- dygraph(.mockData())
  makeHtml(graph)

  ## better way, using existing technology
  library(dygraphs)
  library(rmarkdown)
  render('dygraphs_demo.Rmd', output_format='html_document')

  
  
  
}
