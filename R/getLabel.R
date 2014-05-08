getLabel = function(object) UseMethod("getLabel")

getLabel.default = function(x) {
  stop("Invalid object. Must supply a graph or node object.")
}

getLabel.graph = function(graph) {
  url = paste0(graph$root, "labels")
  result = fromJSON(httpGET(url))
  
  if(length(result) == 0) {
    cat("No labels in this graph.")
    return(invisible(NULL))
  }
  
  return(result)
}

getLabel.node = function(node) {
  url = node$labels
  result = fromJSON(httpGET(url))
  
  if(length(result) == 0) {
    cat("No labels on this node.")
    return(invisible(NULL))
  }
  
  return(result)
}
