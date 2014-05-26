dropIndex = function(graph, label = character(), key = character(), all = FALSE) UseMethod("dropIndex")

dropIndex.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

dropIndex.graph = function(graph, label = character(), key = character(), all = FALSE) {
  stopifnot(is.character(label), is.character(key), is.logical(all))
  
  constraint = suppressMessages(getConstraint(graph))
  
  # If user sets all=TRUE, drop all indices from the graph.
  if(all) {
    
    index = suppressMessages(getIndex(graph))
        
    if(is.null(index)) {
      message("No indexes to drop.")
      return(invisible(NULL))
    }
    
    # Check if uniqueness constraint exists on any of the indices.
    test = merge(index, constraint)
    
    if(nrow(test) > 0) {
      stop("There is a uniqueness constraint on one of the indexes. Drop the constraint(s) instead (which necessarily drops the index as well) with dropConstraint().")
    }
    
    urls = apply(index, 1, function(x) {paste(attr(graph, "indexes"), x[2], x[1], sep = "/")})
    lapply(urls, function(x) {httpDELETE(x)})
    return(invisible(NULL))
    
  # Else, drop the index for the label and key given.
  } else if (length(label) == 1 & length(key) == 1) {
    
    index = suppressMessages(getIndex(graph, label))
    
    # Check if the index exists.
    stopifnot(key %in% index$property_keys)
    
    # Check if uniqueness constraint exists on the index.
    test = merge(index, constraint)
    
    if(nrow(test) > 0) {
      stop(paste0("There is a uniqueness constraint on (", label, ", ", key, "). Drop the constraint instead (which necessarily drops the index as well) using dropConstraint()."))
    }
    
    url = paste(attr(graph, "indexes"), label, key, sep = "/")
    httpDELETE(url)
    return(invisible(NULL))
    
  # Else, user supplied an invalid combination of arguments.  
  } else {
    stop("Arguments supplied are invalid.")
  }
}

