getConstraint = function(graph, label = character()) UseMethod("getConstraint")

getConstraint.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getConstraint.graph = function(graph, label = character()) {
  stopifnot(is.character(label))
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  url = attr(graph, "constraints")
  
  # If label is not given, get constraints for entire graph.
  if(length(label) == 0) {
    response = fromJSON(httpGET(url, httpheader = headers))
    
    if(length(response) == 0) {
      message("No constraints in the graph.")
      return(invisible(NULL))
    }
    
  # Else, if label is given, only get constraint on label.  
  } else if(length(label) == 1) {
    # Check if label exists.
    stopifnot(label %in% getLabel(graph))
    url = paste(url, label, "uniqueness", sep = "/")
    response = fromJSON(httpGET(url, httpheader = headers))
    
    if(length(response) == 0) {
      message(paste0("No constraints for label ", label, "."))
      return(invisible(NULL))
    }
    
  # Else, user supplied an invalid combination of arguments.  
  } else {
    stop("Arguments supplied are invalid.")
  }
  
  keys = do.call(rbind.data.frame, response)
  rownames(keys) = NULL
  return(keys)
}