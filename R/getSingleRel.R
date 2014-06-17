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
  if(unlist(strsplit(result$self, "/"))[6] != "relationship") {
    stop("The entity returned is not a relationship. Check that your query is returning a relationship.")
  }
  class(result) = c("entity", "relationship")
  rel = configure_result(result)
  return(rel)
}