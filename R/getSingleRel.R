getSingleRel = function(graph, query, ...) UseMethod("getSingleRel")

getSingleRel.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getSingleRel.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)

  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  params = list(...)  
  fields = list(query = query)

  if(length(params) > 0)
    fields = c(fields, params = list(params))

  fields = toJSON(fields)
  response = fromJSON(httpPOST(attr(graph, "cypher"), httpheader = headers, postfields = fields))
  
  if(length(response$data) == 0) {
    message("Relationship not found.")
    return(invisible(NULL))
  }
  
  result = response$data[[1]][[1]]
  class(result) = c("entity", "relationship")
  rel = configure_result(result)
  return(rel)
}