#' Retrieve Nodes from Paths
#' 
#' Retrieve all nodes from a path object.
#' 
#' @param path A path object.
#' 
#' @return A list of node objects.
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
#' createRel(alice, "WORKS_WITH", bob)
#' createRel(bob, "WORKS_WITH", charles)
#' 
#' query = "
#' MATCH p = (:Person {name:'Alice'})-[:WORKS_WITH*]->(:Person {name:'Charles'}) 
#' RETURN p
#' "
#' 
#' path = cypherToList(graph, query)[[1]]$p
#' 
#' nodes(path)
#' }
#' 
#' @seealso \code{\link{rels}}
#' 
#' @export
nodes = function(path) UseMethod("nodes")

#' @export
nodes.path = function(path) {
  urls = attr(path, "nodes")

  FUN <- function(x) {
    url = x
    result = http_request(url, "GET")
    node = configure_result(result)
    return(node)
  }
  nodes = lapply(urls, FUN)
  return(nodes)
}