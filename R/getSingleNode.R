getSingleNode = function(graph, query, ...) UseMethod("getSingleNode")

getSingleNode.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getSingleNode.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)

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
                          fields,
                          header)
  
  result = fromJSON(response)
  
  if(length(result$data) == 0) {
    message("Node not found.")
    return(invisible(NULL))
  }
  
  result = result$data[[1]][[1]]
  if(!is.null(result$start)) {
    stop("At least one entity returned is not a node. Check that your query is returning nodes.")
  }
  class(result) = c("entity", "node")
  node = configure_result(result, attr(graph, "username"), attr(graph, "password"))
  return(node)
}