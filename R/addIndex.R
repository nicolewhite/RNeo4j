addIndex = function(graph, label, key) UseMethod("addIndex")

addIndex.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

addIndex.graph = function(graph, label, key) {
  stopifnot(is.character(label), 
            is.character(key),
            length(label) == 1,
            length(key) == 1)
  
  # Test if the index exists.
  index = suppressMessages(getIndex(graph))
  test = merge(data.frame(property_keys = key, label = label), index)
  
  if(nrow(test) > 0) {
    stop(paste0("An index already exists for (", label, ", ", key, "). It's possible that you added a uniqueness constraint on this (label, key) pair, which necessarily adds an index as well."))
  }
  
  # Add the index.
  fields = paste0('{\n "property_keys": [ "', key, '" ] \n}')
  url = paste0(attr(graph, "indexes"), "/", label)
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  httpPOST(url, httpheader = headers, postfields = fields)
  return(invisible(NULL))
}
