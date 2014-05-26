getUniqueNode = function(graph, label, ...) UseMethod("getUniqueNode")

getUniqueNode.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getUniqueNode.graph = function(graph, label, ...) {
  stopifnot(is.character(label))
  
  param = c(...)
  
  if(length(param) > 1)
    stop("Can only search by one property.")
  
  if(length(param) == 0)
    stop("Must supply a key = value pair.")
  
  # Check if uniqueness constraint exists.
  stopifnot(names(param) %in% getConstraint(graph, label)$property_keys,
            !is.null(names(param)))
  
  url = paste0(attr(graph, "root"), "/label/", label, "/nodes?", names(param), "=%22", gsub(" ", "+", param[[1]]), "%22")
  response = fromJSON(httpGET(url))
  
  if(length(response) == 0) {
    message("No node found.")
    return(invisible(NULL))
  }
  
  result = response[[1]]
  class(result) = c("entity", "node")
  node = configure_result(result)
  return(node)
}