outgoingRels = function(node, ...) UseMethod("outgoingRels")

outgoingRels.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

outgoingRels.node = function(node, ...) {  
  url = attr(node, "outgoing_relationships")
  type = c(...)
  
  if(length(type) > 0) {
    stopifnot(is.character(type))
    url = paste(url, paste(type, collapse = "%26"), sep = "/")
  }
    
  result = http_request(url, "GET", node)

  if(length(result) == 0) {
    message("No outgoing relationships.")
    return(invisible())
  }
  
  outgoing_rels = lapply(result, function(r) configure_result(r, attr(node, "username"), attr(node, "password"), attr(node, "auth_token")))
  return(outgoing_rels)
}