getRels = function(graph, query, ...) UseMethod("getRels")

getRels.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getRels.graph = function(graph, query, ...) {
  stopifnot(is.character(query))
  
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
  result = result$data
  
  if(length(result) == 0) {
    message("No relationships found.")
    return(invisible(NULL))
  }
  
  set_class = function(i) {
    current = result[[i]][[1]]
    if(unlist(strsplit(current$self, "/"))[6] != "relationship") {
      stop("At least one entity returned is not a relationship. Check that your query is returning relationships.")
    }
    class(current) = c("entity", "relationship")
    return(current)
  }
  
  result = lapply(1:length(result), set_class)
  rels = lapply(result, configure_result)
  return(rels)
}