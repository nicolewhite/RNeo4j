dropConstraint = function(graph, label = character(), key = character(), all = FALSE) UseMethod("dropConstraint")

dropConstraint.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

dropConstraint.graph = function(graph, label = character(), key = character(), all = FALSE) {
  stopifnot(is.character(label), 
            is.character(key),
            is.logical(all))
  
  url = attr(graph, "constraints")
  
  # If user sets all=TRUE, drop all uniqueness constraints from the graph.
  if(all) {
    constraints = suppressMessages(getConstraint(graph))
    
    if(is.null(constraints)) {
      message("No constraints to drop.")
      return(invisible())
    }
    
    urls = apply(constraints, 1, function(c) paste(url, c['label'], "uniqueness", c['property_keys'], sep = "/"))
    lapply(urls, function(u) http_request(u, "DELETE", graph))
    return(invisible())
    
  # Else, drop the uniqueness constraint for the label and key given.
  } else if (length(label) == 1 & length(key) == 1) {    
    url = paste(url, label, "uniqueness", key, sep = "/")
    http_request(url, "DELETE", graph)
    return(invisible())
  
  # Else, user supplied an invalid combination of arguments.
  } else {
    stop("Arguments supplied are invalid.")
  }
}