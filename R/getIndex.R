getIndex = function(graph, label = character()) UseMethod("getIndex")

getIndex.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getIndex.graph = function(graph, label = character()) {
  stopifnot(is.character(label))
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  
  # If label not provided, get indices for the entire graph.
  if(length(label) == 0) {
    labels = fromJSON(httpGET(paste0(attr(graph, "root"), "labels")))
    
    # If there are no labels in the graph, there can't be indices.
    if(length(labels) == 0) {
      message("No indices in the graph.")
      return(invisible(NULL))
    }
    
    urls = vapply(labels, function(x) {paste0(attr(graph, "root"), "schema/index/", x)}, "")
    get = function(x) {fromJSON(httpGET(x, httpheader = headers))}
    response = lapply(urls, get)
    
    df = lapply(response, function(x) {do.call(rbind.data.frame, x)})
    df = do.call(rbind.data.frame, df)
    
    if(is.empty(df)) {
      message("No indices in the graph.")
      return(invisible(NULL))
    }
    
    row.names(df) = NULL
    return(df)
  }
  
  # Else, get index for the specified label.
  else if(length(label) == 1) {
    # Check if label exists.
    stopifnot(label %in% getLabel(graph))
    
    url = paste0(attr(graph, "root"), "schema/index/", label)
    response = fromJSON(httpGET(url, httpheader = headers))
    
    if(length(response) == 0) {
      message(paste0("No index for label ", label, "."))
      return(invisible(NULL))
    }
    
    keys = do.call(rbind.data.frame, response)
    rownames(keys) = NULL
    return(keys)
    
    # Else, user supplied an invalid combination of arguments.  
  } else {
    stop("Arguments supplied are invalid.")
  }
}