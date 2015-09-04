#' Nodes
#' 
#' Create a node in the graph with the given label and properties.
#' 
#' @param graph A graph object.
#' @param .label A character string.
#' @param ... A named list. Node properties in the form key = value.
#' 
#' @return A node object.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' bob = createNode(graph, "Person", name = "Bob", age = 24, kids = c("Jenny", "Larry"))
#' charles = createNode(graph, c("Person", "Student"), name = "Charles", age = 21)
#' 
#' props = list(name="David", age = 26)
#' david = createNode(graph, "Person", props)
#' }
#' 
#' @export 
createNode = function(graph, .label = character(), ...) UseMethod("createNode")

#' @export 
createNode.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

#' @export 
createNode.graph = function(graph, .label = character(), ...) {
  stopifnot(is.character(.label))
  
  dots = list(...)
  props = parse_dots(dots)
  body = NULL
  if(length(props) > 0) {
    body = props
  }
  
  url = attr(graph, "node")
  
  result = http_request(url, "POST", graph, body)
  
  node = configure_result(result, attr(graph, "username"), attr(graph, "password"))

  if(length(.label) > 0) {
    if(length(grep(" ", .label)) > 0) {
      stop("Cannot have spaces in labels. Use CamelCase instead.")
    }
    test = try(addLabel(node, .label), TRUE)
    if("try-error" %in% class(test)) {
      delete(node)
      stop(test)
    }
  }
  return(node)
}