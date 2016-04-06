#' Retrieve Paths with Cypher Queries
#' 
#' Deprecated. Use \code{\link{cypherToList}}. Retrieve paths from the graph with a Cypher query.
#' 
#' @param graph A graph object.
#' @param query A character string.
#' @param ... Parameters to pass to the query in the form key = value, if applicable.
#' 
#' @return A list of path objects.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice", age = 23)
#' bob = createNode(graph, "Person", name = "Bob", age = 22)
#' charles = createNode(graph, "Person", name = "Charles", age = 25)
#' 
#' createRel(alice, "KNOWS", bob)
#' createRel(alice, "KNOWS", charles)
#' 
#' query = "MATCH p = (:Person {name:'Alice'})-[:KNOWS]->(:Person) RETURN p"
#' 
#' paths = getPaths(graph, query)
#' 
#' lapply(paths, startNode)
#' lapply(paths, endNode)
#' }
#' 
#' @seealso \code{\link{getSinglePath}}
#' 
#' @export
getPaths = function(graph, query, ...) UseMethod("getPaths")

#' @export
getPaths.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)
  
  params = list(...)  
  result = cypher_endpoint(graph, query, params)
  result = result$data
  
  if(length(result) == 0) {
    return(invisible())
  }
  
  for(i in 1:length(result)) {
    current = result[[i]][[1]]
    is.path = try(current$self, silent = T)
    if(!is.null(is.path) | class(is.path) == "try-error") {
      stop("At least one entity returned is not a path. Check that your query is returning paths.")
    }
    result[[i]] = current
  }
  
  paths = lapply(result, function(r) configure_result(r))
  return(paths)
}