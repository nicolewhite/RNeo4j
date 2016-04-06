#' Node Labels
#' 
#' Drop the specified label(s) from a node.
#' 
#' @param node A node object.
#' @param ... A character vector.
#' @param all A logical constant. If \code{TRUE}, drop all labels from the node.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice")
#' bob = createNode(graph, c("Person", "Student"), name = "Bob")
#' 
#' dropLabel(alice, "Person")
#' dropLabel(bob, all = TRUE)
#' 
#' alice
#' bob
#' }
#' 
#' @seealso \code{\link{addLabel}}, \code{\link{getLabel}}
#' 
#' @export
dropLabel = function(node, ..., all = FALSE) UseMethod("dropLabel")

#' @export
dropLabel.node = function(node, ..., all = FALSE) {
  stopifnot(is.logical(all))
  labels = c(...)
  url = attr(node, "labels")
    
  if(all) {
    labels = getLabel(node)
  } else if(length(labels) > 0) {
    stopifnot(is.character(labels))
  } else{
    stop("Must supply labels to be dropped or set all = TRUE.")
  }
  
  labels = vapply(labels, function(label) URLencode(label, reserved = TRUE), "")
  urls = vapply(labels, function(label) paste(url, label, sep = "/"), "")
  
  for (i in 1:length(urls)) {
    http_request(urls[[i]], "DELETE")
  }
  
  return(invisible())
}