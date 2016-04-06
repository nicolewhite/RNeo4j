#' Indexes
#' 
#' Add an index to a node label and property key.
#' 
#' An index already exists for any (label, key) pair that has a uniqueness constraint applied. 
#' Attempting to add an index where a uniqueness constraint already exists results in an error. 
#' Use \code{\link{getConstraint}} to view any pre-existing uniqueness constraints. 
#' If a uniqueness constraint already exists for the (label, key) pair, then it must be true that the index exists as well; adding an index is unnecessary.
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
#' createNode(graph, "Person", name="Alice", status="Employed")
#' 
#' addIndex(graph, "Person", "status")
#' }
#' 
#' @seealso \code{\link{getIndex}}, \code{\link{dropIndex}}
#' 
#' @export
addIndex = function(graph, label, key) UseMethod("addIndex")

#' @export
addIndex.graph = function(graph, label, key) {
  stopifnot(is.character(label), 
            is.character(key),
            length(label) == 1,
            length(key) == 1)
  
  field = list(property_keys = key)
  url = paste(attr(graph, "indexes"), label, sep = "/")
  http_request(url, "POST", field)
  
  return(invisible())
}
