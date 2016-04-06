#' Retrieve Relationships from Nodes
#' 
#' Retreive a list of incoming relationship objects from a node object, optionally filtering by relationship type.
#' 
#' @param node A node object.
#' @param ... A character vector.
#' 
#' @return A list of relationship objects.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice")
#' bob = createNode(graph, "Person", name = "Bob")
#' charles = createNode(graph, "Person", name = "Charles")
#' david = createNode(graph, "Person", name = "David")
#' 
#' createRel(alice, "KNOWS", bob)
#' createRel(alice, "KNOWS", charles)
#' createRel(charles, "KNOWS", david)
#' 
#' createRel(alice, "WORKS_WITH", david)
#' createRel(bob, "WORKS_WITH", david)
#' createRel(bob, "WORKS_WITH", charles)
#' 
#' incomingRels(david)
#' incomingRels(charles, "WORKS_WITH")
#' }
#' 
#' @seealso \code{\link{outgoingRels}}
#' 
#' @export
incomingRels = function(node, ...) UseMethod("incomingRels")

#' @export
incomingRels.node = function(node, ...) {
  url = attr(node, "incoming_relationships")
  type = c(...)
  
  if(length(type) > 0) {
    stopifnot(is.character(type))
    url = paste(url, paste(type, collapse = "%26"), sep = "/")
  }
  
  result = http_request(url, "GET")
  
  if(length(result) == 0) {
    return(invisible())
  }

  incoming_rels = lapply(result, function(r) configure_result(r))
  return(incoming_rels)
}