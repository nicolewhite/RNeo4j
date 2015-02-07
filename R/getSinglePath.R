getSinglePath = function(graph, query, ...) UseMethod("getSinglePath")

getSinglePath.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getSinglePath.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)
  
  params = list(...)  
  result = cypher_endpoint(graph, query, params)
  result = result$data
  
  if(length(result) == 0) {
    return(invisible(NULL))
  }
  
  result = result[[1]][[1]]
  
  is.path = try(result$self, silent = T)
  if(!is.null(is.path) | class(is.path) == "try-error") {
    stop("The entity returned is not a path. Check that your query is returning a path.")
  }
  
  class(result) = "path"
  path = configure_result(result, attr(graph, "username"), attr(graph, "password"), attr(graph, "auth_token"))
  return(path)
}