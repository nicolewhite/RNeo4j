dropLabel = function(node, ...) UseMethod("dropLabel")

dropLabel.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

dropLabel.node = function(node, ...) {
  labels = c(...)
  stopifnot(is.character(labels))
  
  urls = vapply(labels, function(x) {paste0(attr(node, "labels"), "/", x)}, "")
  lapply(urls, function(x) {httpDELETE(x)})
  return(invisible(NULL))
}