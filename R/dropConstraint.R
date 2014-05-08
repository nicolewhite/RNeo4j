dropConstraint = function(graph, label = character(), key = character(), all = FALSE) UseMethod("dropConstraint")

dropConstraint.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

dropConstraint.graph = function(graph, label = character(), key = character(), all = FALSE) {
  stopifnot(is.character(label), is.character(key), is.logical(all))
  
  # If user sets all=TRUE, drop all uniqueness constraints from the graph.
  if(all) {
    df = suppressMessages(getConstraint(graph))
    
    if(is.null(df)) {
      message("No constraints to drop.")
      return(invisible(NULL))
    }
    
    urls = apply(df, 1, function(x) {paste0(graph$root, "schema/constraint/", x[2], "/uniqueness/", x[1])})
    lapply(urls, function(x) {httpDELETE(x)})
    return(invisible(NULL))
    
  # Else, drop the uniqueness constraint for the label and key given.
  } else if (length(label) == 1 & length(key) == 1) {
    # Check if the constraint exists.
    stopifnot(key %in% getConstraint(graph, label)$property_keys)
    
    url = paste0(graph$root, "schema/constraint/", label, "/uniqueness/", key)
    httpDELETE(url)
    return(invisible(NULL))
  
  # Else, user supplied an invalid combination of arguments.
  } else {
    stop("Arguments supplied are invalid.")
  }
}