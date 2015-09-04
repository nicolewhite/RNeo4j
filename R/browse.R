#' Neo4j Browser
#' 
#' Open the Neo4j browser either in the viewer pane or in the default browser.
#' 
#' @param graph A graph object.
#' @param viewer A logical constant. If \code{TRUE}, open the browser in the viewer pane; otherwise, open in the default browser.
#' 
#' @examples
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' browse(graph)
#' }
#' 
#' @export
browse = function(graph, viewer = TRUE) UseMethod("browse", graph)

#' @export
browse.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

#' @export
browse.graph = function(graph, viewer = TRUE) {
  url <- sub("db/data", "browser", attr(graph, "root"))
  if (Sys.getenv("RSTUDIO") == "1" & viewer & grepl('localhost', url)) {
    if('rstudio' %in% names(installed.packages()[, 1])) {
      rstudio::viewer(url)
    } else {
      rstudioapi::viewer(url)
    }
  } else {
    browseURL(url)
  }
}
