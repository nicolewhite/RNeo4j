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
getType.default = function(x) {
  stop("Invalid object. Must supply relationship or graph object.")
}

#' @export
getType.graph = function(graph) {
  url = attr(graph, "relationship_types")
  headers = setHeaders(graph)
  response = http_request(url, "GET", "OK", httpheader=headers)
  result = fromJSON(response)
  return(result)
}

getType.relationship = function(rel) {
  return(attr(rel, "type"))
}