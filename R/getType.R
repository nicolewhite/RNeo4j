#' Relationship Types
#' 
#' Get the type of a relationship object or all relationship types in the graph.
#' 
#' @param object A relationship or graph object.
#' 
#' @return A character vector.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice")
#' bob = createNode(graph, "Person", name = "Bob")
#' charles = createNode(graph, "Person", name = "Charles")
#' 
#' createRel(bob, "WORKS_WITH", charles)
#' rel = createRel(alice, "KNOWS", bob)
#' 
#' getType(rel)
#' 
#' getType(graph)
#' }
#' 
#' @export
getType = function(object) UseMethod("getType")

#' @export
getType.graph = function(object) {
  url = attr(object, "relationship_types")
  response = http_request(url, "GET")
  return(response)
}

#' @export
getType.relationship = function(object) {
  return(attr(object, "type"))
}