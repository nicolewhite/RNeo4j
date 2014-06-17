getConstraint = function(graph, label = character()) UseMethod("getConstraint")

getConstraint.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getConstraint.graph = function(graph, label = character()) {
  stopifnot(is.character(label))
  
  header = setHeaders()
  url = attr(graph, "constraints")
  
  # If label is not given, get constraints for entire graph.
  if(length(label) == 0) {
    response = http_request(url, "GET", "OK", httpheader = header)
    result = fromJSON(response)
    
    if(length(result) == 0) {
      message("No constraints in the graph.")
      return(invisible(NULL))
    }
    
  # Else, if label is given, only get constraint on label.  
  } else if(length(label) == 1) {
    if(!(label %in% getLabel(graph))) {
      message("Label '", label, "' does not exist.")
      return(invisible(NULL))
    }
    
    url = url = paste(url, label, "uniqueness", sep = "/")
    response = http_request(url, "GET", "OK", httpheader = header)
    result = fromJSON(response)
    
    if(length(result) == 0) {
      message(paste0("No constraints for label '", label, "'."))
      return(invisible(NULL))
    }
    
  # Else, user supplied an invalid combination of arguments.  
  } else {
    stop("Arguments supplied are invalid.")
  }
  
  df = do.call(rbind.data.frame, result)
  rownames(df) = NULL
  return(df)
}