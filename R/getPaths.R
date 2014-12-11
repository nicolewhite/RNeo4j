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
    return(invisible(NULL))
  }
  
  set_class = function(i) {
    current = result[[i]][[1]]
    is.path = try(current$self, silent = T)
    if(!is.null(is.path) | class(is.path) == "try-error") {
      stop("At least one entity returned is not a path. Check that your query is returning paths.")
    }
    class(current) = "path"
    return(current)
  }
  
  result = lapply(1:length(result), set_class)
  paths = lapply(result, function(r) configure_result(r, attr(graph, "username"), attr(graph, "password")))
  return(paths)
}