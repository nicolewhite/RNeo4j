#' Create Unique Node or Retrieve Unique Node
#' 
#' Create a unique node or retrieve it if it already exists.
#' 
#' A uniqueness constraint must exist for the given node label and first key = value pair 
#' listed in \code{...}. Use \code{\link{addConstraint}} to add a uniqueness constraint.
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
#' createNode(graph, "Person", name = "Alice", age = 24)
#' createNode(graph, "Person", name = "Bob", age = 21)
#' 
#' addConstraint(graph, "Person", "name")
#' 
#' # Alice is retrieved from the graph; a new node is not created.
#' alice = getOrCreateNode(graph, "Person", name = "Alice")
#' 
#' # Additional properties listed after the unique key = value 
#' # pair are ignored if the node is retrieved instead of
#' # created.
#' bob = getOrCreateNode(graph, "Person", name = "Bob", age = 22)
#' 
#' # Node doesn't exist, so it is created.
#' charles = getOrCreateNode(graph, "Person", name = "Charles")
#' 
#' # There are now three nodes in the graph.
#' length(getLabeledNodes(graph, "Person"))
#' }
#' 
#' @export
getOrCreateNode = function(graph, .label, ...) UseMethod("getOrCreateNode")

#' @export
getOrCreateNode.graph = function(graph, .label, ...) {
  stopifnot(is.character(.label))
  
  dots = list(...)
  props = parse_dots(dots)
  
  if(!(names(props)[[1]] %in% getConstraint(graph, .label)$property_keys)) {
    stop("The first key = value pair listed in ... must be uniquely constrained for the given node label.")
  }
            
  node = try(createNode(graph, .label, ...), TRUE)
  
  if("try-error" %in% class(node)) {
    node = getUniqueNode(graph, .label, props[1])
  }
  
  return(node)
}