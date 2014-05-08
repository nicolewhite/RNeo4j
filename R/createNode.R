createNode = function(graph, label = character(), ...) UseMethod("createNode")

createNode.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

createNode.graph = function(graph, label = character(), ...) {
  stopifnot(is.character(label))
  
  props = list(...)
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  
  if(length(props) == 0) {
    node = fromJSON(httpPOST(graph$node, 
                             httpheader = headers))
  } else {
    fields = toJSON(props)
    node = fromJSON(httpPOST(graph$node, 
                             httpheader = headers, 
                             postfields = fields))
  }
  
  class(node) = c("entity", "node")
  
  if(length(label) > 0)
    addLabel(node, label)

  return(node)
}