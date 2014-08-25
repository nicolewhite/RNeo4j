getIndex = function(graph, label = character()) UseMethod("getIndex")

getIndex.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getIndex.graph = function(graph, label = character()) {
  stopifnot(is.character(label))
  
  url = attr(graph, "indexes")
  
  # If label not provided, get indexes for the entire graph.
  if(length(label) == 0) {
    labels = suppressMessages(getLabel(graph))
    result = list()
    if(length(labels) == 0) {
      message("No indexes in the graph.")
      return(invisible(NULL))
    }
    urls = lapply(labels, function(l) paste(url, l, sep = "/"))
    for(i in 1:length(urls)) {
      response = http_request(urls[[i]], "GET", "OK")
      response = fromJSON(response)
      if(length(response) == 0) {
        next
      }
      result = c(result, response)
    }
    
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