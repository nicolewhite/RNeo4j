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
getLabel.graph = function(object) {
  url = attr(object, "node_labels")
  result = http_request(url, "GET")
  if(length(result) == 0) {
    return(invisible())
  }
  return(unlist(result))
}

#' @export
getLabel.node = function(object) {
  url = attr(object, "labels")
  result = http_request(url, "GET")
  if(length(result) == 0) {
    return(invisible())
  }
  return(unlist(result))
}
