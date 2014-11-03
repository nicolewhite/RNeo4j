getSinglePath = function(graph, query, ...) UseMethod("getSinglePath")

getSinglePath.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getSinglePath.graph = function(graph, query, ...) {
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
    return(invisible(NULL))
  }
  
  result = result$data[[1]][[1]]
  is.path = try(result$self, silent = T)
  if(!is.null(is.path) | class(is.path) == "try-error") {
    stop("The entity returned is not a path. Check that your query is returning a path.")
  }
  class(result) = "path"
  path = configure_result(result, attr(graph, "username"), attr(graph, "password"))
  return(path)
}