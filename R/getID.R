#' Internal IDs
#' 
#' Retrieve the internal ID of a node or relationship object.
#' 
#' @param entity A node or relationship object.
#' 
#' @return An integer.
#' 
#' @examples
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice")
#' getID(alice)
#' }
#' 
#' @export
getID = function(entity) UseMethod("getID")

#' @export
getID.entity = function(entity) {
  id = as.numeric(unlist(strsplit(unlist(strsplit(attr(entity, "self"), "db/data/"))[2], "/"))[2])
  return(id)
}
