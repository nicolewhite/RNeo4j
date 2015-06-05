incomingRels = function(node, ...) UseMethod("incomingRels")

incomingRels.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

incomingRels.node = function(node, ...) {
  url = attr(node, "incoming_relationships")
  type = c(...)
  
  if(length(type) > 0) {
    stopifnot(is.character(type))
    url = paste(url, paste(type, collapse = "%26"), sep = "/")
  }
  
  result = http_request(url, "GET", node)
  
  if(length(result) == 0) {
    message("No incoming relationships for the given type(s).")
    return(invisible())
  }

  incoming_rels = lapply(result, function(r) configure_result(r, attr(node, "username"), attr(node, "password")))
  return(incoming_rels)
}