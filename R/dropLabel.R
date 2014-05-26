dropLabel = function(node, ...) UseMethod("dropLabel")

dropLabel.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

dropLabel.node = function(node, ...) {
  labels = c(...)
  stopifnot(is.character(labels))
  
  urls = vapply(labels, function(x) {paste(attr(node, "labels"), x, sep = "/")}, "")
  lapply(urls, function(x) {httpDELETE(x)})
  return(invisible(NULL))
}