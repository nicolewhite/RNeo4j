getNodeByIndex = function(graph, label, key, value) UseMethod("getNodeByIndex")

getNodeByIndex.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

getNodeByIndex.graph = function(graph, label, key, value) {
  stopifnot(is.character(label),
            length(label) == 1,
            is.character(key),
            length(key) == 1,
            length(value) == 1,
            key %in% getIndex(graph, label)$property_keys)
  
  url = paste0(graph$root, "label/", label, "/nodes?", key, "=%22", gsub(" ", "+", value), "%22")
  response = fromJSON(httpGET(url))
  node = response[[1]]
  
  class(node) = c("entity", "node")
  return(node)
}