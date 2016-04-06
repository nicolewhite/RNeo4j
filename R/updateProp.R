#' Update Node and Relationship Properties
#' 
#' For a node or relationship object, update its properties. 
#' Existing properties can be overridden and new properties can be added.
#' 
#' @param entity A node or relationship object.
#' @param ... A named list. Property updates in the form key = value.
#' 
#' @return A node or relationship object.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice")
#' bob = createNode(graph, "Person", name = "Bob")
#' 
#' alice = updateProp(alice, age = 24, eyes = "green")
#' 
#' newProps = list(age = 25, eyes = "brown")
#' bob = updateProp(bob, newProps)
#' 
#' alice
#' bob
#' }
#' 
#' @seealso \code{\link{deleteProp}}
#' 
#' @export
updateProp = function(entity, ...) UseMethod("updateProp")

#' @export
updateProp.entity = function(entity, ...) {
  dots = list(...)
  props = parse_dots(dots)
  
  if(length(props) == 0)
    stop("Must supply properties to update.")
  
  for (i in 1:length(props)) {
    key = names(props[i])
    value = props[[i]]
    url = paste(attr(entity, "properties"), key, sep = "/")
    http_request(url, "PUT", value)
    entity[key] = props[key]
  }
  
  return(entity)
}