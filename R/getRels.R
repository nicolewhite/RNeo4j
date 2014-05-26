getRels = function(graph, query, ...) UseMethod("getRels")

getRels.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getRels.graph = function(graph, query, ...) {
  stopifnot(is.character(query))
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  params = list(...)  
  fields = list(query = query)
  
  if(length(params) > 0)
    fields = c(fields, params = list(params))
  
  fields = toJSON(fields)
  response = fromJSON(httpPOST(attr(graph, "cypher"), httpheader = headers, postfields = fields))
  rels = response$data
  
  if(length(rels) == 0) {
    message("No relationships found.")
    return(invisible(NULL))
  }
  
  FUN = function(i) {
    class(rels[[i]][[1]]) = c("entity", "relationship")
    return(rels[[i]][[1]])
  }
  
  rels = lapply(1:length(rels), FUN)
  rels = lapply(rels, configure_result)
  return(rels)
}