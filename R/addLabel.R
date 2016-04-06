#' Node Labels
#' 
#' Add a label or multiple labels to an existing node object.
#' 
#' @param node A node object.
#' @param ... A character vector.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, name = "Alice")
#' bob = createNode(graph, name = "Bob")
#' 
#' addLabel(alice, "Person")
#' addLabel(bob, c("Person", "Student"))
#' 
#' alice
#' bob
#' }
#' 
#' @seealso \code{\link{getLabel}}, \code{\link{dropLabel}}
#' 
#' @export
addLabel = function(node, ...) UseMethod("addLabel")

#' @export
addLabel.node = function(node, ...) {
  labels = c(...)
  stopifnot(is.character(labels), length(labels) > 0)
  
  if(length(grep(" ", labels)) > 0) {
    stop("Cannot have spaces in labels. Use CamelCase instead.")
  }
  
  if(length(labels) == 1) {
    fields = paste0(' "', labels, '" ')
  } else {
    fields = labels
  }
  
  url = attr(node, "labels")
  
  for (i in 1:length(labels)) {
    field = paste0(' "', labels[i], '" ')
    http_request(url, "POST", labels)
  }
  return(invisible())
}
