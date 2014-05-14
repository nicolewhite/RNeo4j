getNodeByIndex = function(graph, label, ...) UseMethod("getNodeByIndex")

getNodeByIndex.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getNodeByIndex.graph = function(graph, label, ...) {
  stopifnot(is.character(label))
  
  param = c(...)
  
  if(length(param) > 1) {
    stop("Can only search by one property.")
  }
  
  # Check if index exists.
  stopifnot(names(param) %in% getIndex(graph, label)$property_keys,
            !is.null(names(param)))
  
  url = paste0(attr(graph, "root"), "label/", label, "/nodes?", names(param), "=%22", gsub(" ", "+", param[[1]]), "%22")
  response = fromJSON(httpGET(url))
  result = response[[1]]
  class(result) = c("entity", "node")
  node = configure_result(result)
  return(node)
}