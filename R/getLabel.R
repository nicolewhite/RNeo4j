getLabel = function(object) UseMethod("getLabel")

getLabel.default = function(x) {
  stop("Invalid object. Must supply a graph or node object.")
}

getLabel.graph = function(graph) {
  url = paste0(attr(graph, "root"), "labels")
  result = fromJSON(httpGET(url))
  
  if(length(result) == 0) {
    message("No labels in this graph.")
    return(invisible(NULL))
  }
  
  return(result)
}

getLabel.node = function(node) {
  url = attr(node, "labels")
  result = fromJSON(httpGET(url))
  
  if(length(result) == 0) {
    message("No labels on this node.")
    return(invisible(NULL))
  }
  
  return(result)
}
