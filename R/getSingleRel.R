#' Retrieve Relationships with Cypher Queries
#' 
#' Deprecated. Use \code{\link{cypherToList}}. Retrieve a single relationship from the graph with a Cypher query.
#' 
#' @param graph A graph object.
#' @param query A character string.
#' @param ... Parameters to pass to the query in the form key = value, if applicable.
#' 
#' @return A relationship object.
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
#' createRel(bob, "KNOWS", charles, since = 2000, through = "Work")
#' 
#' query = "MATCH (:Person {name:'Alice'})-[r:WORKS_WITH]->(:Person {name:'Bob'})
#'          RETURN r"
#' 
#' getSingleRel(graph, query)
#' 
#' query = "MATCH (:Person {name:{start}})-[r:KNOWS]->(:Person {name:{end}})
#'          RETURN r"
#' 
#' getSingleRel(graph, query, start = "Bob", end = "Charles")
#' }
#' 
#' @seealso \code{\link{getRels}}
#' 
#' @export
getSingleRel = function(graph, query, ...) UseMethod("getSingleRel")

#' @export
getSingleRel.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)

  params = list(...)  
  result = cypher_endpoint(graph, query, params)
  result = result$data
  
  if(length(result) == 0) {
    return(invisible())
  }
  
  result = result[[1]][[1]]
  
  is.rel = try(result$labels, silent = T)
  if(!is.null(is.rel) | class(is.rel) == "try-error") {
    stop("The entity returned is not a relationship. Check that your query is returning a relationship.")
  }
  
  rel = configure_result(result)
  return(rel)
}