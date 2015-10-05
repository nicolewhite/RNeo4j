#' Cypher Queries to Lists
#' 
#' Retrieve Cypher query results as a list.
#' 
#' @param graph A graph object.
#' @param query A character string.
#' @param ... A named list. Parameters to pass to the query in the form key = value, if applicable.
#' 
#' @return A list.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice", age = 23)
#' bob = createNode(graph, "Person", name = "Bob", age = 22)
#' charles = createNode(graph, "Person", name = "Charles", age = 25)
#' david = createNode(graph, "Person", name = "David", age = 20)
#' 
#' createRel(alice, "KNOWS", bob)
#' createRel(alice, "KNOWS", charles)
#' createRel(charles, "KNOWS", david)
#' 
#' cypherToList(graph, "MATCH n RETURN n, n.age")
#' 
#' cypherToList(graph, "MATCH (n)-[:KNOWS]-(m) 
#'                      RETURN n, COLLECT(m) AS friends, COUNT(m) AS num_friends")
#' 
#' cypherToList(graph, "MATCH p = (n)-[:KNOWS]-(m) RETURN p")
#' 
#' cypherToList(graph, "MATCH p = (n)-[:KNOWS]-(m) 
#'                      WHERE n.name = {name} 
#'                      RETURN p", name="Alice")
#' }
#' 
#' @seealso \code{\link{cypher}}
#' 
#' @export
cypherToList = function(graph, query, ...) UseMethod("cypherToList")

#' @export
cypherToList.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)
  
  dots = list(...)
  params = parse_dots(dots)
  result = cypher_endpoint(graph, query, params)
  data = result$data
  
  if(length(data) == 0) {
    return(invisible(list()))
  }
  
  response = list()
  
  for(i in 1:length(data)) {
    datum = list()
    for(j in 1:length(result$columns)) {
      name = result$columns[[j]]
      record = data[[i]][[j]]
      if(!is.null(names(record)) || !is.list(record) || length(record) == 0) {
        datum[[name]] = configure_result(record)
      } else {
        depth = length(record)
        datumdatum = list()
        for(k in 1:depth) {
          datumdatum[[k]] = configure_result(record[[k]])
        }
        datum[[name]] = datumdatum
      }
    }
    response[[i]] = datum
  }
  
  return(response)
}