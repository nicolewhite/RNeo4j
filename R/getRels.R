#' Retrieve Relationships with Cypher Queries
#' 
#' Deprecated. Use \code{\link{cypherToList}}. Retrieve relationships from the graph with a Cypher query.
#' 
#' @param graph A graph object.
#' @param query A character string.
#' @param ... Parameters to pass to the query in the form key = value, if applicable.
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
#' createRel(bob, "WORKS_WITH", david)
#' createRel(alice, "WORKS_WITH", david)
#' 
#' getRels(graph, "MATCH (:Person)-[k:KNOWS]->(:Person) RETURN k")
#' getRels(graph, "MATCH (:Person {name:{name}})-[r]->(:Person) RETURN r", name = "Alice")
#' }
#' 
#' @seealso \code{\link{getSingleRel}}
#' 
#' @export
getRels = function(graph, query, ...) UseMethod("getRels")

#' @export
getRels.graph = function(graph, query, ...) {
  stopifnot(is.character(query))
  
  params = list(...)  
  result = cypher_endpoint(graph, query, params)
  result = result$data
  
  if(length(result) == 0) {
    return(invisible())
  }
  
  for(i in 1:length(result)) {
    result[[i]] = result[[i]][[1]]
  }
  
  rels = lapply(result, function(r) configure_result(r))
  return(rels)
}