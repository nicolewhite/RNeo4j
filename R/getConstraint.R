#' Uniqueness Constraints
#' 
#' Get all uniqueness constraints for a given label or for the entire graph database.
#' 
#' Omitting the \code{label} argument returns all uniqueness constraints in the graph database.
#' 
#' @param graph A graph object.
#' @param label A character string.
#' 
#' @return A data.frame.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' addConstraint(graph, "Person", "name")
#' addConstraint(graph, "City", "name")
#' 
#' getConstraint(graph, "Person")
#' getConstraint(graph)
#' }
#' 
#' @seealso \code{\link{addConstraint}}, \code{\link{dropConstraint}}
#' 
#' @export
getConstraint = function(graph, label = character()) UseMethod("getConstraint")

#' @export
getConstraint.graph = function(graph, label = character()) {
  stopifnot(is.character(label))
  
  url = attr(graph, "constraints")
  
  # If label is not given, get constraints for entire graph.
  if(length(label) == 0) {
    result = http_request(url, "GET", graph)
    
    if(length(result) == 0) {
      return(invisible())
    }
    
  # Else, if label is given, only get constraint on label.  
  } else if(length(label) == 1) {
    if(!(label %in% getLabel(graph))) {
      return(invisible())
    }
    
    url = url = paste(url, label, "uniqueness", sep = "/")
    result = http_request(url, "GET", graph)
    
    if(length(result) == 0) {
      return(invisible())
    }
    
  # Else, user supplied an invalid combination of arguments.  
  } else {
    stop("Arguments supplied are invalid.")
  }
  
  for(i in 1:length(result)) {
    result[[i]]['property_keys'] = result[[i]]['property_keys'][[1]][[1]]
  }
  
  df = do.call(rbind.data.frame, result)
  rownames(df) = NULL
  return(df)
}