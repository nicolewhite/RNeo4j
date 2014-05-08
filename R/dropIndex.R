dropIndex = function(graph, label = character(), key = character(), all = FALSE) UseMethod("dropIndex")

dropIndex.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

dropIndex.graph = function(graph, label = character(), key = character(), all = FALSE) {
  stopifnot(is.character(label), is.character(key), is.logical(all))
  
  # If user sets all=TRUE, drop all indices from the graph.
  if(all) {
    df = suppressMessages(getIndex(graph))
    
    if(is.null(df)) {
      message("No indices to drop.")
      return(invisible(NULL))
    }
    
    urls = apply(df, 1, function(x) {paste0(graph$root, "schema/index/", x[2], "/", x[1])})
    lapply(urls, function(x) {httpDELETE(x)})
    return(invisible(NULL))
    
  # Else, drop the index for the label and key given.
  } else if (length(label) == 1 & length(key) == 1) {
    # Check if the index exists.
    stopifnot(key %in% getIndex(graph, label)$property_keys)
    
    url = paste0(graph$root, "schema/index/", label, "/", key)
    httpDELETE(url)
    return(invisible(NULL))
    
  # Else, user supplied an invalid combination of arguments.  
  } else {
    stop("Arguments supplied are invalid.")
  }
}