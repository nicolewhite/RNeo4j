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
    return(invisible())
  }
  
  for(i in 1:length(result)) {
    result[[i]] = result[[i]][[1]]
  }
  
  rels = lapply(result, function(r) configure_result(r, attr(graph, "username"), attr(graph, "password"), attr(graph, "auth_token")))
  return(rels)
}