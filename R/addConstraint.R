#' Uniqueness Constraints
#' 
#' Add a uniqueness constraint to a label and property key.
#' 
#' A uniqueness constraint cannot be added to a (label, key) pair that already has an index applied. 
#' Attempting to add a uniqueness constraint where an index already exists results in an error. 
#' Use \code{\link{getIndex}} to view any pre-existing indexes. 
#' If you wish to add a uniqueness constraint, use \code{\link{dropIndex}} to drop the index.
#' 
#' @param graph A graph object.
#' @param label A character string.
#' @param key A character string.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' addConstraint(graph, "Person", "name")
#' 
#' createNode(graph, "Person", name = "Alice")
#' createNode(graph, "Person", name = "Bob")
#' try(createNode(graph, "Person", name = "Alice"))
#' }
#' 
#' @seealso \code{\link{getConstraint}}, \code{\link{dropConstraint}}
#' 
#' @export
addConstraint = function(graph, label, key) UseMethod("addConstraint")

#' @export
addConstraint.graph = function(graph, label, key) {
  stopifnot(is.character(label), 
            is.character(key),
            length(label) == 1,
            length(key) == 1)
    
  fields = list(property_keys = key)
  url = paste(attr(graph, "constraints"), label, "uniqueness", sep = "/")
  http_request(url, "POST", fields)
  
  return(invisible())
}