addLabel = function(node, ...) UseMethod("addLabel")

addLabel.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

addLabel.node = function(node, ...) {
  labels = c(...)
  stopifnot(is.character(labels), length(labels) > 0)
  
    if(length(labels) == 1) {
    fields = paste0(' "', labels, '" ')
  } else {
    fields = toJSON(labels)
  }

  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json') 
  test = try(httpPOST(attr(node, "labels"), httpheader = headers, postfields = fields), TRUE)
  if(class(test) == "try-error") {
    stop("Uniqueness constraint violated.")
  }
  return(invisible(NULL))
}
