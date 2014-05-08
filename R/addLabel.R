addLabel = function(node, ...) UseMethod("addLabel")

addLabel.default = function(x) {
  stop("Invalid object. Must supply node object.")
}

addLabel.node = function(node, label = character()) {
  stopifnot(is.character(label))
  
  if(length(label) == 0)
    return()
  
    if(length(label) == 1) {
    fields = paste0(' "', label, '" ')
  } else {
    fields = toJSON(label)
  }

  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  httpPOST(node$labels, httpheader = headers, postfields = fields)
  
  return(invisible(NULL))
}
