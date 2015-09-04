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
#' path = getSinglePath(graph, query)
#' 
#' endNode(path)
#' }
#' 
#' @seealso \code{\link{startNode}}
#' 
#' @export
endNode = function(object) UseMethod("endNode")

#' @export
endNode.default = function(x) {
  stop("Invalid object. Must supply a relationship or path object.")
}

#' @export
endNode.relationship = function(rel) {
  url = attr(rel, "end")
  result = http_request(url, "GET", rel)
  node = configure_result(result, attr(rel, "username"), attr(rel, "password"), attr(rel, "auth_token"))
  return(node)
}

#' @export
endNode.path = function(path) {
  url = attr(path, "end")
  result = http_request(url, "GET", path)
  node = configure_result(result, attr(path, "username"), attr(path, "password"), attr(path, "auth_token"))
  return(node)
}