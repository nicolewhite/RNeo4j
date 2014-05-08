addConstraint = function(graph, label, key) UseMethod("addConstraint")

addConstraint.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

addConstraint.graph = function(graph, label, key) {
  stopifnot(is.character(label), 
            is.character(key),
            length(label) == 1,
            length(key) == 1)
    
  # Check if index for given (label, key) pair already exists.
  index = suppressMessages(getIndex(graph))

  if(key %in% index$property_keys & label %in% index$label) {
    stop("An index already exists for this (label, key) pair. 
          Remove this index before attempting to apply a uniqueness constraint to this (label, key) pair. 
          See ?addConstraint.")
  }

  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  fields = paste0('{\n "property_keys": [ \"', key, '" ] \n}')
  url = paste0(graph$root, "schema/constraint/", label, "/uniqueness")
  httpPOST(url, httpheader = headers, postfields = fields)
  return(invisible(NULL))
}