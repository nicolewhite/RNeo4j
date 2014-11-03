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

  if(length(params) > 0) {
    max_digits = find_max_dig(params)
    fields = c(fields, params = list(params))
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
    return(invisible(NULL))
  }
  
  result = result$data[[1]][[1]]
  is.rel = try(result$labels, silent = T)
  if(!is.null(is.rel) | class(is.rel) == "try-error") {
    stop("The entity returned is not a relationship. Check that your query is returning a relationship.")
  }
  class(result) = c("entity", "relationship")
  rel = configure_result(result, attr(graph, "username"), attr(graph, "password"))
  return(rel)
}