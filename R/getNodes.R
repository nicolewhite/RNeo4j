getNodes = function(graph, query, ...) UseMethod("getNodes")

getNodes.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getNodes.graph = function(graph, query, ...) {
  stopifnot(is.character(query))
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  params = list(...)  
  fields = list(query = query)
  
  if(length(params) > 0)
    fields = c(fields, params = list(params))
  
  fields = toJSON(fields)
  response = fromJSON(httpPOST(attr(graph, "cypher"), httpheader = headers, postfields = fields))
  nodes = response$data
  
  if(length(nodes) == 0) {
    message("No nodes found.")
    return(invisible(NULL))
  }
  
  FUN = function(i) {
    class(nodes[[i]][[1]]) = c("entity", "node")
    return(nodes[[i]][[1]])
  }
  
  nodes = lapply(1:length(nodes), FUN)
  nodes = lapply(nodes, configure_result)
  return(nodes)
}