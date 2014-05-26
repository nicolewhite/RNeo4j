outgoingRels = function(node, ..., limit = numeric()) UseMethod("outgoingRels")

outgoingRels.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

outgoingRels.node = function(node, ..., limit = numeric()) {
  stopifnot(is.numeric(limit))
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  url = attr(node, "outgoing_relationships")
  type = c(...)
  
  if(length(type) > 0) {
    stopifnot(is.character(type))
    url = paste(url, paste(type, collapse = "%26"), sep = "/")
  }
    
  if(length(limit) > 0) {
    outgoing_rels = fromJSON(httpGET(url, httpheader = headers))[1:limit]
  } else {
    outgoing_rels = fromJSON(httpGET(url, httpheader = headers))
  }
  
  if(length(outgoing_rels) == 0) {
    message("No outgoing relationships.")
    return(invisible(NULL))
  }
  
  FUN = function(i) {
    class(outgoing_rels[[i]]) = c("entity", "relationship")
    return(outgoing_rels[[i]])
  }
  
  outgoing_rels = lapply(1:length(outgoing_rels), FUN)
  outgoing_rels = lapply(outgoing_rels, configure_result)
  return(outgoing_rels)
}