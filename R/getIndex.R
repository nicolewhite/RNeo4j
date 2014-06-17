getIndex = function(graph, label = character()) UseMethod("getIndex")

getIndex.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getIndex.graph = function(graph, label = character()) {
  stopifnot(is.character(label))
  
  url = attr(graph, "indexes")
  
  # If label not provided, get indexes for the entire graph.
  if(length(label) == 0) {
    response = http_request(url, "GET", "OK")
    result = fromJSON(response)
    
    if(length(result) == 0) {
      message("No indexes in the graph.")
      return(invisible(NULL))
    }
  }
  
  # Else, get index for the specified label.
  else if(length(label) == 1) {
    if(!(label %in% getLabel(graph))) {
      message("Label '", label, "' does not exist.")
      return(invisible(NULL))
    }
    
    url = paste(url, label, sep = "/")
    response = http_request(url, "GET", "OK")
    result = fromJSON(response)
    
    if(length(result) == 0) {
      message(paste0("No index for label '", label, "'."))
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