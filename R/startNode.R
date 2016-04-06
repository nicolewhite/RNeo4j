#' Retrieve Nodes from Relationships or Paths
#' 
#' Retrieve the start node from a relationship or path object.
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
#' startNode(rel)
#' 
#' query = "
#' MATCH p = (a:Person)-[:WORKS_WITH]->(b:Person)
#' WHERE a.name = 'Alice' AND b.name = 'Bob'
#' RETURN p
#' "
#' 
#' path = getSinglePath(graph, query)
#' 
#' startNode(path)
#' }
#' 
#' @seealso \code{\link{endNode}}
#' 
#' @export
startNode = function(object) UseMethod("startNode")

#' @export
startNode.relationship = function(object) {
  url = attr(object, "start")
  result = http_request(url, "GET")
  node = configure_result(result)
  return(node)
}

#' @export
startNode.path = function(object) {
  url = attr(object, "start")
  result = http_request(url, "GET")
  node = configure_result(result)
  return(node)
}