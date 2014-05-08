addIndex = function(graph, label, key) UseMethod("addIndex")

addIndex.defult = function(x) {
  stop("Invalid object. Must supply graph object.")
}

addIndex.graph = function(graph, label, key) {
  stopifnot(is.character(label), 
            is.character(key),
            length(label) == 1,
            length(key) == 1)
  
  constraint = suppressMessages(getConstraint(graph))
  
  if(key %in% constraint$property_keys & label %in% constraint$label) {
    stop("A uniqueness constraint already exists for this (label, key) pair. 
          Thus, it must be true that an index already exists for this (label, key) pair.
          See ?addIndex.")
  }
  
  fields = paste0('{\n "property_keys": [ "', key, '" ] \n}')
  url = paste0(graph$root, "schema/index/", label)
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  httpPOST(url, httpheader = headers, postfields = fields)
  return(invisible(NULL))
}
