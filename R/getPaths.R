getPaths = function(graph, query, ...) UseMethod("getPaths")

getPaths.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

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
  
  paths = lapply(result, function(r) configure_result(r, attr(graph, "username"), attr(graph, "password"), attr(graph, "auth_token")))
  return(paths)
}