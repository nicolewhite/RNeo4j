getSingleNode = function(graph, query, ...) UseMethod("getSingleNode")

getSingleNode.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getSingleNode.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)

  params = list(...)  
  result = cypher_endpoint(graph, query, params)
  result = result$data
  
  if(length(result) == 0) {
    return(invisible(NULL))
  }
  
  result = result[[1]][[1]]
  
  is.node = try(result$start, silent = T)
  if(!is.null(is.node) | class(is.node) == "try-error") {
    stop("The entity returned is not a node. Check that your query is returning a node.")
  }
  
  class(result) = c("entity", "node")
  node = configure_result(result, attr(graph, "username"), attr(graph, "password"))
  return(node)
}