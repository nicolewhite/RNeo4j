#' Retrieve Relationships from Paths
#' 
#' Retrieve all relationships from a path object.
#' 
#' @param path A path object.
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
#' rels(path)
#' }
#' 
#' @seealso \code{\link{nodes}}
#' 
#' @export
rels = function(path) UseMethod("rels")

#' @export
rels.path = function(path) {
  urls = attr(path, "relationships")

  FUN <- function(x) {
    url = x
    result = http_request(url, "GET")
    rel = configure_result(result)
    return(rel)
  }
  rels = lapply(urls, FUN)
  return(rels)
}