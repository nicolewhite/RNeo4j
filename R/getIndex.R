#' Indexes
#' 
#' Get all indexes for a given label or for the entire graph database.
#' 
#' Omitting the \code{label} argument returns all indexes in the graph database.
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
  
  # If label not provided, get indexes for the entire graph.
  if(length(label) == 0) {
    labels = suppressMessages(getLabel(graph))
    result = list()
    if(length(labels) == 0) {
      return(invisible())
    }
    urls = lapply(labels, function(l) paste(url, l, sep = "/"))
    for(i in 1:length(urls)) {
      response = http_request(urls[[i]], "GET", graph)
      if(length(response) == 0) {
        next
      }
      result = c(result, response)
    }
    
    if(length(result) == 0) {
      return(invisible())
    }
  }
  
  # Else, get index for the specified label.
  else if(length(label) == 1) {
    if(!(label %in% getLabel(graph))) {
      return(invisible())
    }
    
    url = paste(url, label, sep = "/")
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