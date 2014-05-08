getNodeByIndex = function(graph, label, ...) UseMethod("getNodeByIndex")

getNodeByIndex.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

getNodeByIndex.graph = function(graph, label, ...) {
  stopifnot(is.character(label))
  
  params = c(...)
  
  if(length(params) > 1) {
    stop("Can only search by one property.")
  }
  
  # Check if index exists.
  stopifnot(names(params) %in% getIndex(graph, label)$property_keys)
  
  url = paste0(graph$root, "label/", label, "/nodes?", names(params), "=%22", gsub(" ", "+", params[[1]]), "%22")
  response = fromJSON(httpGET(url))
  node = response[[1]]
  
  class(node) = c("entity", "node")
  return(node)
}