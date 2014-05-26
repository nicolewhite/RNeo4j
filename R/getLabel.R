getLabel = function(object) UseMethod("getLabel")

getLabel.default = function(x) {
  stop("Invalid object. Must supply a graph or node object.")
}

getLabel.graph = function(graph) {
  result = fromJSON(httpGET(attr(graph, "node_labels")))
  
  if(length(result) == 0) {
    message("No labels in the graph.")
    return(invisible(NULL))
  }
  
  return(result)
}

getLabel.node = function(node) {
  result = fromJSON(httpGET(attr(node, "labels")))
  
  if(length(result) == 0) {
    message("No labels on the node.")
    return(invisible(NULL))
  }
  
  return(result)
}
