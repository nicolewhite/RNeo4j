#' Retrieve Paths with Cypher Queries
#' 
#' Deprecated. Use \code{\link{cypherToList}}. Retrieve a single path from the graph with a Cypher query.
#' 
#' @param graph A graph object.
#' @param query A character string.
#' @param ... Parameters to pass to the query in the form key = value, if applicable.
#' 
#' @return A path object.
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
#' query = "MATCH p = (:Person {name:'Alice'})-[:KNOWS]->(:Person {name:'Bob'}) RETURN p"
#' 
#' getSinglePath(graph, query)
#' 
#' query = "MATCH p = (:Person {name:'Alice'})-[:KNOWS]->(:Person {name:{name}}) RETURN p"
#' 
#' getSinglePath(graph, query, name = "Charles")
#' }
#' 
#' @seealso \code{\link{getPaths}}
#' 
#' @export
getSinglePath = function(graph, query, ...) UseMethod("getSinglePath")

#' @export
getSinglePath.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)
  
  params = list(...)  
  result = cypher_endpoint(graph, query, params)
  result = result$data
  
  if(length(result) == 0) {
    return(invisible())
  }
  
  result = result[[1]][[1]]
  
  is.path = try(result$self, silent = T)
  if(!is.null(is.path) | class(is.path) == "try-error") {
    stop("The entity returned is not a path. Check that your query is returning a path.")
  }
  
  path = configure_result(result)
  return(path)
}