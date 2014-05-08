getRelByCypher = function(graph, query) UseMethod("getRelByCypher")

getRelByCypher.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

getRelByCypher.graph = function(graph, query) {
  stopifnot(is.character(query),
            length(query) == 1)
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  fields = toJSON(list(query = query))
  response = fromJSON(httpPOST(graph$cypher, httpheader = headers, postfields = fields))
  rel = response$data[[1]][[1]]
  
  class(rel) = c("entity", "relationship")
  return(rel)
}