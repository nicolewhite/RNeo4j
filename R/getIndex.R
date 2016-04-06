#' Indexes
#' 
#' Get all indexes for a given label or for the entire graph database.
#' 
#' Omitting the \code{label} argument returns all indexes in the graph database.
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
#' addIndex(graph, "Person", "status")
#' addIndex(graph, "School", "type")
#' 
#' getIndex(graph, "Person")
#' getIndex(graph)
#' }
#' 
#' @seealso \code{\link{addIndex}}, \code{\link{dropIndex}}
#' 
#' @export
getIndex = function(graph, label = character()) UseMethod("getIndex")

#' @export
getIndex.graph = function(graph, label = character()) {
  stopifnot(is.character(label))
  
  url = attr(graph, "indexes")
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