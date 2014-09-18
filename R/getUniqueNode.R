getUniqueNode = function(graph, .label, ...) UseMethod("getUniqueNode")

getUniqueNode.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getUniqueNode.graph = function(graph, .label, ...) {
  stopifnot(is.character(.label))
  
  param = c(...)
  
  if(length(param) > 1)
    stop("Can only search by one property.")
  
  if(length(param) == 0)
    stop("Must supply a key = value pair.")
  
  # Check if uniqueness constraint exists.
  keys = invisible(getConstraint(graph, .label))$property_keys
  if(!(names(param) %in% keys)) {
    stop("The key = value pair given must have a uniqueness constraint applied.")
  }
  
  url = paste0(attr(graph, "root"), "/label/", .label, "/nodes?", names(param), "=")
  
  if(is.character(param[[1]])) {
    param[[1]] = URLencode(param[[1]], reserved = TRUE)
    url = paste0(url, "%22", param[[1]], "%22")
  } else if(is.numeric(param[[1]])) {
    url = paste0(url, param[[1]])
  } else if(is.logical(param[[1]])) {
    if(param[[1]]) {
      url = paste0(url, "true")
    } else {
      url = paste0(url, "false")
    }
  } else {
    stop("Property value must be character, numeric, or logical.")
  }
  
  header = setHeaders()
  response = http_request(url,
                          "GET",
                          "OK",
                          httpheader = header)
  
  result = fromJSON(response)
  
  if(length(result) == 0) {
    message("No node found.")
    return(invisible(NULL))
  }
  
  result = result[[1]]
  class(result) = c("entity", "node")
  node = configure_result(result, attr(graph, "username"), attr(graph, "password"))
  return(node)
}
