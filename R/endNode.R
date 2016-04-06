#' Retrieve Nodes from Relationships or Paths
#' 
#' Retrieve the end node from a relationship or path object.
#' 
#' @param object A relationship or path object.
#' 
#' @return A node object.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice")
#' bob = createNode(graph, "Person", name = "Bob")
#' 
#' rel = createRel(alice, "WORKS_WITH", bob)
#' 
#' endNode(rel)
#' 
#' query = "
#' MATCH p = (a:Person)-[:WORKS_WITH]->(b:Person)
#' WHERE a.name = 'Alice' AND b.name = 'Bob'
#' RETURN p
#' "
#' 
#' path = cypherToList(graph, query)[[1]]$p
#' 
#' endNode(path)
#' }
#' 
#' @seealso \code{\link{startNode}}
#' 
#' @export
endNode = function(object) UseMethod("endNode")

#' @export
endNode.relationship = function(object) {
  url = attr(object, "end")
  result = http_request(url, "GET")
  node = configure_result(result)
  return(node)
}

#' @export
endNode.path = function(object) {
  url = attr(object, "end")
  result = http_request(url, "GET")
  node = configure_result(result)
  return(node)
}