#' Uniqueness Constraints
#' 
#' Drop uniqueness constraint(s) for a given label and property key or for the entire graph database.
#' 
#' @param graph A graph object.
#' @param label A character string.
#' @param key A character string.
#' @param all A logical constant. If \code{TRUE}, drop all constraints in the graph.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' addConstraint(graph, "Person", "name")
#' getConstraint(graph)
#' 
#' dropConstraint(graph, "Person", "name")
#' getConstraint(graph)
#' }
#' 
#' @seealso \code{\link{addConstraint}}, \code{\link{getConstraint}}
#' 
#' @export
dropConstraint = function(graph, label = character(), key = character(), all = FALSE) UseMethod("dropConstraint")

#' @export
dropConstraint.graph = function(graph, label = character(), key = character(), all = FALSE) {
  stopifnot(is.character(label), 
            is.character(key),
            is.logical(all))
  
  url = attr(graph, "constraints")
  
  # If user sets all=TRUE, drop all uniqueness constraints from the graph.
  if(all) {
    constraints = suppressMessages(getConstraint(graph))
    
    if(is.null(constraints)) {
      return(invisible())
    }
    
    urls = apply(constraints, 1, function(c) paste(url, c['label'], "uniqueness", c['property_keys'], sep = "/"))
    lapply(urls, function(u) http_request(u, "DELETE"))
    return(invisible())
    
  # Else, drop the uniqueness constraint for the label and key given.
  } else if (length(label) == 1 & length(key) == 1) {    
    url = paste(url, label, "uniqueness", key, sep = "/")
    http_request(url, "DELETE")
    return(invisible())
  
  # Else, user supplied an invalid combination of arguments.
  } else {
    stop("Arguments supplied are invalid.")
  }
}