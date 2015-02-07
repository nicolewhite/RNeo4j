dropLabel = function(node, ..., all = FALSE) UseMethod("dropLabel")

dropLabel.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

dropLabel.node = function(node, ..., all = FALSE) {
  stopifnot(is.logical(all))
  labels = c(...)
  url = attr(node, "labels")
  
  headers = setHeaders(node)
  
  if(all) {
    all_labels = getLabel(node)
    all_labels = vapply(all_labels, function(label) URLencode(label, reserved = TRUE), "")
    urls = vapply(all_labels, function(label) paste(url, label, sep = "/"), "")
    for(i in 1:length(urls)) {
      http_request(urls[[i]],
                   "DELETE",
                   "No Content",
                   httpheader=headers)
    }
    return(invisible(NULL))
    
  } else if(length(labels) > 0) {
    stopifnot(is.character(labels))
    labels = vapply(labels, function(label) URLencode(label, reserved = TRUE), "")
    urls = vapply(labels, function(label) paste(url, label, sep = "/"), "")
  
    for (i in 1:length(urls)) {
      http_request(urls[[i]],
                   "DELETE",
                   "No Content",
                   httpheader=headers)
    }
    return(invisible(NULL))
  
  } else{
    stop("Must supply labels to be dropped or set all = TRUE.")
  }
}