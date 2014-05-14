getNodeByCypher = function(graph, query) UseMethod("getNodeByCypher")

getNodeByCypher.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getNodeByCypher.graph = function(graph, query) {
  stopifnot(is.character(query),
            length(query) == 1)

  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  fields = toJSON(list(query = query))
  response = fromJSON(httpPOST(attr(graph, "cypher"), httpheader = headers, postfields = fields))
  result = response$data[[1]][[1]]
  class(result) = c("entity", "node")
  node = configure_result(result)
  return(node)
}