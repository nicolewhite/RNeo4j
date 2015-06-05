dropIndex = function(graph, label = character(), key = character(), all = FALSE) UseMethod("dropIndex")

dropIndex.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

dropIndex.graph = function(graph, label = character(), key = character(), all = FALSE) {
  stopifnot(is.character(label), 
            is.character(key), 
            is.logical(all))
  
  url = attr(graph, "indexes")
  constraints = suppressMessages(getConstraint(graph))
  
  # If user sets all=TRUE, drop all indexes from the graph.
  if(all) {
    indexes = suppressMessages(getIndex(graph))
        
    if(is.null(indexes)) {
      message("No indexes to drop.")
      return(invisible(NULL))
    }
    
    overlap = merge(indexes, constraints)
    
    if(nrow(overlap) > 0) {
      errors = c()
      for(i in 1:nrow(overlap)) {
        errors = c(errors, 
                   "There is a uniqueness constraint for label '", overlap[i,'label'], "' on property '", overlap[i,'property_keys'], "'.\n")
      }
      stop(errors,
           "Remove the uniqueness constraint(s) instead using dropConstraint(). This drops the index(es) as well.")
      return(invisible())
    }
    
    urls = apply(indexes, 1, function(x) paste(url, x['label'], x['property_keys'], sep = "/"))
    
    for(i in 1:length(urls)) {
      http_request(urls[i],
                   "DELETE",
                   graph)
    }
    
    return(invisible())
    
  # Else, drop the index for the label and key given.
  } else if (length(label) == 1 & length(key) == 1) {
    index = suppressMessages(getIndex(graph, label))
    overlap = merge(index, constraints)
    
    if(nrow(overlap) > 0) {
      stop("There is a uniqueness constraint on label '", label, "' with property '", key, "'. ",
           "Remove the uniqueness constraint instead using dropConstraint(). This drops the index as well.")
    }
    
    url = paste(url, label, key, sep = "/")
    http_request(url, "DELETE", graph)
    return(invisible())
    
  # Else, user supplied an invalid combination of arguments.  
  } else {
    stop("Arguments supplied are invalid.")
  }
}

