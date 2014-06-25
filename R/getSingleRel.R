getSingleRel = function(graph, query, ...) UseMethod("getSingleRel")

getSingleRel.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getSingleRel.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)

  header = setHeaders()
  params = list(...)  
  fields = list(query = query)

  if(length(params) > 0)
    fields = c(fields, params = list(params))

  fields = toJSON(fields)
  url = attr(graph, "cypher")
  response = http_request(url,
                          "POST",
                          "OK",
                          fields,
                          header)
  result = fromJSON(response)
  
  if(length(result$data) == 0) {
    message("Relationship not found.")
    return(invisible(NULL))
  }
  
  result = result$data[[1]][[1]]
  if(!is.null(result$labels)) {
    stop("At least one entity returned is not a relationship. Check that your query is returning relationships.")
  }
  class(result) = c("entity", "relationship")
  rel = configure_result(result, attr(graph, "username"), attr(graph, "password"))
  return(rel)
}