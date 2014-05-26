incomingRels = function(node, ..., limit = numeric()) UseMethod("incomingRels")

incomingRels.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

incomingRels.node = function(node, ..., limit = numeric()) {
  stopifnot(is.numeric(limit))
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  url = attr(node, "incoming_relationships")
  type = c(...)
  
  if(length(type) > 0) {
    stopifnot(is.character(type))
    url = paste(url, paste(type, collapse = "%26"), sep = "/")
  }
  
  if(length(limit) > 0) {
    incoming_rels = fromJSON(httpGET(url, httpheader = headers))[1:limit]
  } else {
    incoming_rels = fromJSON(httpGET(url, httpheader = headers))
  }
  
  if(length(incoming_rels) == 0) {
    message("No incoming relationships.")
    return(invisible(NULL))
  }
  
  FUN = function(i) {
    class(incoming_rels[[i]]) = c("entity", "relationship")
    return(incoming_rels[[i]])
  }
  
  incoming_rels = lapply(1:length(incoming_rels), FUN)
  incoming_rels = lapply(incoming_rels, configure_result)
  return(incoming_rels)
}