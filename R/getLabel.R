#' Node Labels
#' 
#' Get all node labels for a given node object or for the entire graph database.
#' 
#' @param object A graph or node object.
#' 
#' @return A character vector.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice")
#' bob = createNode(graph, c("Person", "Student"), name = "Bob")
#' 
#' getLabel(alice)
#' getLabel(graph)
#' }
#' 
#' @seealso \code{\link{addLabel}}, \code{\link{dropLabel}}
#' 
#' @export
getLabel = function(object) UseMethod("getLabel")

#' @export
getLabel.default = function(x) {
  stop("Invalid object. Must supply a graph or node object.")
}

#' @export
getLabel.graph = function(graph) {
  url = attr(graph, "node_labels")
  result = http_request(url, "GET", graph)
  if(length(result) == 0) {
    message("No labels in the graph.")
    return(invisible())
  }
  return(unlist(result))
}

#' @export
getLabel.node = function(node) {
  url = attr(node, "labels")
  result = http_request(url, "GET", node)
  if(length(result) == 0) {
    message("No labels on the node.")
    return(invisible())
  }
  return(unlist(result))
}
