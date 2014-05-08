getNodeByCypher = function(graph, query) UseMethod("getNodeByCypher")

getNodeByCypher.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

getNodeByCypher.graph = function(graph, query) {
  stopifnot(is.character(query))

  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  fields = toJSON(list(query = query))
  response = fromJSON(httpPOST(graph$cypher, httpheader = headers, postfields = fields))
  node = response$data[[1]][[1]]

  class(node) = c("entity", "node")
  return(node)
}