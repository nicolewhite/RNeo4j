createNode = function(graph, label = character(), ...) UseMethod("createNode")

createNode.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

createNode.graph = function(graph, label = character(), ...) {
  stopifnot(is.character(label))
  
  props = list(...)
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  
  if(length(props) == 0) {
    result = fromJSON(httpPOST(attr(graph, "node"), 
                               httpheader = headers))
  } else {
    fields = toJSON(props)
    result = fromJSON(httpPOST(attr(graph, "node"), 
                               httpheader = headers, 
                               postfields = fields))
  }
  
  class(result) = c("node", "entity")
  node = configure_result(result)

  if(length(label) > 0) {
    test = try(addLabel(node, label), TRUE)
    if("try-error" %in% class(test)) {
      delete(node)
      stop("Uniqueness constraint violated.")
    }
    return(node)
  }
  return(node)
}