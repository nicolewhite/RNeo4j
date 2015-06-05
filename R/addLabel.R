addLabel = function(node, ...) UseMethod("addLabel")

addLabel.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

addLabel.node = function(node, ...) {
  labels = c(...)
  stopifnot(is.character(labels), length(labels) > 0)
  
  if(length(grep(" ", labels)) > 0) {
    stop("Cannot have spaces in labels. Use CamelCase instead.")
  }
  
  if(length(labels) == 1) {
    fields = paste0(' "', labels, '" ')
  } else {
    fields = labels
  }
  
  url = attr(node, "labels")
  
  for (i in 1:length(labels)) {
    field = paste0(' "', labels[i], '" ')
    http_request(url, "POST", node, labels)
  }
  return(invisible())
}
