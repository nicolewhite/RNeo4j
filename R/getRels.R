getRels = function(graph, query, ...) UseMethod("getRels")

getRels.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getRels.graph = function(graph, query, ...) {
  stopifnot(is.character(query))
  
  params = list(...)  
  result = cypher_endpoint(graph, query, params)
  result = result$data
  
  if(length(result) == 0) {
    return(invisible(NULL))
  }
  
  set_class = function(i) {
    current = result[[i]][[1]]
    is.rel = try(current$labels, silent = T)
    if(!is.null(is.rel) | class(is.rel) == "try-error") {
      stop("At least one entity returned is not a relationship. Check that your query is returning relationships.")
    }
    class(current) = c("entity", "relationship")
    return(current)
  }
  
  result = lapply(1:length(result), set_class)
  rels = lapply(result, function(r) configure_result(r, attr(graph, "username"), attr(graph, "password"), attr(graph, "auth_token")))
  return(rels)
}