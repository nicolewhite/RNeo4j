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
#' bob
#' charles
#' 
#' props = list(name="David", age = 26)
#' david = createNode(graph, "Person", props)
#' 
#' david
#' }
#' 
#' @export 
createNode = function(graph, .label = character(), ...) UseMethod("createNode")

#' @export 
createNode.graph = function(graph, .label = character(), ...) {
  stopifnot(is.character(.label))
  
  dots = list(...)
  props = parse_dots(dots)

  query = "CREATE (n"
  
  if(length(.label) > 0) {
    for(i in 1:length(.label)) {
      query = paste0(query, ":", .label[i])
    }
  }

  query = paste0(query, ") ")
  query = ifelse(length(props) > 0, paste0(query, "SET n = {props} "), query)
  query = paste0(query, "RETURN n")
  
  node = cypherToList(graph, query, props = props)[[1]]$n
  
  return(node)
}