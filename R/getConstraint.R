#' Uniqueness Constraints
#' 
#' Get all uniqueness constraints for a given label or for the entire graph database.
#' 
#' Omitting the \code{label} argument returns all uniqueness constraints in the graph database.
#' 
#' @param graph A graph object.
#' @param label A character vector.
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
  result = http_request(url, "GET")
  
  if (length(result) > 0) {
    for(i in 1:length(result)) {
      result[[i]]['property_keys'] = result[[i]]['property_keys'][[1]][[1]]
    }
  } else {
    return(invisible())
  }
  
  df = do.call(rbind.data.frame, result)
  rownames(df) = NULL
  
  if (length(label) > 0) {
    df = df[which(df$label == label), ]
  }
  
  return(df)
}