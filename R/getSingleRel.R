getSingleRel = function(graph, query, ...) UseMethod("getSingleRel")

getSingleRel.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

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
  
  rel = configure_result(result, attr(graph, "username"), attr(graph, "password"), attr(graph, "auth_token"))
  return(rel)
}