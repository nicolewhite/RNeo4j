createNode = function(graph, .label = character(), ...) UseMethod("createNode")

createNode.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

createNode.graph = function(graph, .label = character(), ...) {
  stopifnot(is.character(.label))
  
  header = setHeaders(graph)
  fields = NULL
  
  params = list(...)
  if(length(params) > 0) {
    max_digits = find_max_dig(params)
    fields = toJSON(params, digits = max_digits)
  }

  url = attr(graph, "node")
  response = http_request(url,
                          "POST",
                          "Created",
                          postfields = fields,
                          httpheader = header)
  
  result = fromJSON(response)
  class(result) = c("node", "entity")
  node = configure_result(result, attr(graph, "username"), attr(graph, "password"), attr(graph, "auth_token"))

  if(length(.label) > 0) {
    if(length(grep(" ", .label)) > 0) {
      stop("Cannot have spaces in labels. Use CamelCase instead.")
    }
    test = try(addLabel(node, .label), TRUE)
    if("try-error" %in% class(test)) {
      delete(node)
      stop(test)
    }
  }
  return(node)
}