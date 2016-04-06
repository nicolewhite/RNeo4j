#' Retrieve Nodes by Label and Property
#' 
#' Retrieve a single node from the graph by specifying its label and unique key = value pair.
#' 
#' @param graph A graph object.
#' @param .label A character string.
#' @param ... A named list. A key = value pair by which the node label is uniquely constrained.
#' 
#' @return A node object.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' createNode(graph, "Person", name = "Alice")
#' createNode(graph, "Person", name = "Bob")
#' 
#' addConstraint(graph, "Person", "name")
#' 
#' getUniqueNode(graph, "Person", name = "Alice")
#' }
#' 
#' @seealso \code{\link{getLabeledNodes}}
#' 
#' @importFrom utils URLencode
#' 
#' @export
getUniqueNode = function(graph, .label, ...) UseMethod("getUniqueNode")

#' @export
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
  
  result = http_request(url, "GET")

  if(length(result) == 0) {
    return(invisible())
  }
  
  result = result[[1]]
  node = configure_result(result)
  return(node)
}
