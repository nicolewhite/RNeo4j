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
startNode.default = function(x) {
  stop("Invalid object. Must supply a relationship or path object.")
}

#' @export
startNode.relationship = function(rel) {
  url = attr(rel, "start")
  result = http_request(url, "GET", rel)
  node = configure_result(result, attr(rel, "username"), attr(rel, "password"), attr(rel, "auth_token"))
  return(node)
}

#' @export
startNode.path = function(path) {
  url = attr(path, "start")
  result = http_request(url, "GET", path)
  node = configure_result(result, attr(path, "username"), attr(path, "password"), attr(path, "auth_token"))
  return(node)
}