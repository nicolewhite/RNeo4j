#' Retrieve Nodes with Cypher Queries
#' 
#' Deprecated. Use \code{\link{cypherToList}}. Retrieve nodes from the graph with a Cypher query.
#' 
#' @param graph A graph object.
#' @param query A character string.
#' @param ... Parameters to pass to the query in the form key = value, if applicable.
#' 
#' @return A list of node objects.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' createNode(graph, "Person", name = "Alice", age = 23)
#' createNode(graph, "Person", name = "Bob", age = 22)
#' createNode(graph, "Person", name = "Charles", age = 25)
#' 
#' query = "MATCH (p:Person) 
#'          WHERE p.age < 25 
#'          RETURN p"
#' 
#' younger_than_25 = getNodes(graph, query)
#' 
#' sapply(younger_than_25, function(p) p$name)
#' 
#' query = "MATCH (p:Person) 
#'          WHERE p.age > {age} 
#'          RETURN p"
#' 
#' older_than_22 = getNodes(graph, query, age = 22)
#' 
#' sapply(older_than_22, function(p) p$name)
#' }
#' 
#' @seealso \code{\link{getSingleNode}}
#' 
#' @export
getNodes = function(graph, query, ...) UseMethod("getNodes")

#' @export
getNodes.graph = function(graph, query, ...) {
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

  nodes = lapply(result, function(r) configure_result(r))
  return(nodes)
}