dropIndex = function(graph, label = character(), key = character()) UseMethod("dropIndex")

dropIndex.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

dropIndex.graph = function(graph, label = character(), key = character()) {
  stopifnot(is.character(label), is.character(key))
  headers = list('Accept' = 'application/json')
  
  if(length(label) == 0 & length(key) == 0) {
    df = getIndex(graph)
    
    if(is.null(df)) {
      message("No indices to drop.")
      return(invisible(NULL))
      
    } else {
      urls = apply(df, 1, function(x) {paste0(graph$root, 
                                              "schema/constraint/", 
                                              x[2], 
                                              "/uniqueness/", 
                                              x[1])})
      
      lapply(urls, function(x) {httpDELETE(x, httpheader = headers)})
      return(invisible(NULL))
    }

  } else if (length(label) > 0 & length(key) > 0) {
    url = paste0(graph$root, "schema/constraint/", label, "/uniqueness/", key)
    httpDELETE(url, httpheader = headers)
    return(invisible(NULL))
    
  } else {
    stop("Arguments supplied are invalid.")
  }
}