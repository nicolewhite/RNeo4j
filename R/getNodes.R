getNodes = function(graph, query, ...) UseMethod("getNodes")

getNodes.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getNodes.graph = function(graph, query, ...) {
  stopifnot(is.character(query))
  
  header = setHeaders()
  params = list(...)  
  fields = list(query = query)
  
  if(length(params) > 0) {
    fields = c(fields, params = list(params))
    max_digits = find_max_dig(params)
  }
    
  fields = toJSON(fields, digits = max_digits)
  url = attr(graph, "cypher")
  response = http_request(url,
                          "POST",
                          "OK",
                          postfields = fields,
                          httpheader = header)
  result = fromJSON(response)
  result = result$data
  
  if(length(result) == 0) {
    message("No nodes found.")
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
  nodes = lapply(result, function(r) configure_result(r, attr(graph, "username"), attr(graph, "password")))
  return(nodes)
}