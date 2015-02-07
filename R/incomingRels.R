incomingRels = function(node, ...) UseMethod("incomingRels")

incomingRels.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

incomingRels.node = function(node, ...) {
  header = setHeaders(node)
  url = attr(node, "incoming_relationships")
  type = c(...)
  
  if(length(type) > 0) {
    stopifnot(is.character(type))
    url = paste(url, paste(type, collapse = "%26"), sep = "/")
  }
  
  response = http_request(url,
                          "GET",
                          "OK",
                          httpheader = header)
  result = fromJSON(response)
  
  if(length(result) == 0) {
    message("No incoming relationships for the given type(s).")
    return(invisible(NULL))
  }
  
  set_class = function(i) {
    class(result[[i]]) = c("entity", "relationship")
    return(result[[i]])
  }
  
  result = lapply(1:length(result), set_class)
  incoming_rels = lapply(result, function(r) configure_result(r, attr(node, "username"), attr(node, "password")))
  return(incoming_rels)
}