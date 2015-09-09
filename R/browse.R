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
#' @importFrom utils browseURL
#' 
#' @export
browse = function(graph, viewer = TRUE) UseMethod("browse", graph)

#' @export
browse.graph = function(graph, viewer = TRUE) {
  url <- sub("db/data", "browser", attr(graph, "root"))
  if (rstudioapi::isAvailable() && viewer && grepl("localhost", url)) {
    rstudioapi::viewer(url)
  } else {
    browseURL(url)
  }
}
