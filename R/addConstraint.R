addConstraint = function(graph, label, key) UseMethod("addConstraint")

addConstraint.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

addConstraint.graph = function(graph, label, key) {
  stopifnot(is.character(label), 
            is.character(key),
            length(label) == 1,
            length(key) == 1)
    
  # Check if constraint for given (label, key) pair already exists.
  constraint = suppressMessages(getConstraint(graph))
  test = merge(data.frame(property_keys = key, label = label), constraint)
  
  if(nrow(test) > 0) {
    stop(paste0("A uniqueness constraint already exists for (", label, ", ", key, ")."))
  }
  
  # Check if index for given (label, key) pair already exists.
  # Can't add uniqueness constraints to (label, key) pairs that have already been indexed.
  index = suppressMessages(getIndex(graph))
  test = merge(data.frame(property_keys = key, label = label), index)

  if(nrow(test) > 0) {
    stop(paste0("An index already exists for (", label, ", ", key, "). Drop the index before attempting to add a uniqueness constraint. See ?dropIndex."))
  }

  # Add the constraint.
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  fields = paste0('{\n "property_keys": [ "', key, '" ] \n}')
  url = paste0(attr(graph, "root"), "schema/constraint/", label, "/uniqueness")
  httpPOST(url, httpheader = headers, postfields = fields)
  return(invisible(NULL))
}