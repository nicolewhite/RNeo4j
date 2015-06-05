getLabel = function(object) UseMethod("getLabel")

getLabel.default = function(x) {
  stop("Invalid object. Must supply a graph or node object.")
}

getLabel.graph = function(graph) {
  url = attr(graph, "node_labels")
  result = http_request(url, "GET", graph)
  if(length(result) == 0) {
    message("No labels in the graph.")
    return(invisible())
  }
  return(unlist(result))
}

getLabel.node = function(node) {
  url = attr(node, "labels")
  result = http_request(url, "GET", node)
  if(length(result) == 0) {
    message("No labels on the node.")
    return(invisible())
  }
  return(unlist(result))
}
