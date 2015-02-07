getNodes = function(graph, query, ...) UseMethod("getNodes")

getNodes.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getNodes.graph = function(graph, query, ...) {
  stopifnot(is.character(query))
  
  params = list(...)
  result = cypher_endpoint(graph, query, params)
  result = result$data
  
  if(length(result) == 0) {
    return(invisible(NULL))
  }
  
  set_class = function(i) {
    current = result[[i]][[1]]
    is.node = try(current$start, silent = T)
    if(!is.null(is.node) | class(is.node) == "try-error") {
      stop("At least one entity returned is not a node. Check that your query is returning nodes.")
    }
    class(current) = c("entity", "node")
    return(current)
  }
  
  result = lapply(1:length(result), set_class)
  nodes = lapply(result, function(r) configure_result(r, attr(graph, "username"), attr(graph, "password"), attr(graph, "auth_token")))
  return(nodes)
}