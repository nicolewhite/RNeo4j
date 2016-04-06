#' Delete Nodes and Relationships
#' 
#' Delete node or relationship object(s) from the graph.
#' 
#' Nodes with incoming or outgoing relationships cannot be deleted. 
#' All incoming and outgoing relationships need to be deleted before the node can be deleted.
#' 
#' @param ... A list of entities to delete.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, name = "Alice")
#' bob = createNode(graph, name = "Bob")
#' 
#' rel = createRel(alice, "WORKS_WITH", bob)
#' 
#' delete(rel)
#' delete(alice, bob)
#' }
#' 
#' @export
delete = function(...) UseMethod("delete")

#' @export
delete.default = function(...) {
  entities = list(...)
  classes = lapply(entities, class)
  stopifnot(all(vapply(classes, function(c) "entity" %in% c, logical(1))))
  
  urls = vapply(entities, function(x) (attr(x, "self")), "")
  
  for(i in 1:length(urls)) {
    http_request(urls[i], "DELETE")
  }
  
  return(invisible())
}