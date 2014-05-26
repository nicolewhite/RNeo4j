getLabeledNodes = function(graph, label, ..., limit = numeric()) UseMethod("getLabeledNodes")

getLabeledNodes.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getLabeledNodes.graph = function(graph, label, ..., limit = numeric()) {
  stopifnot(is.character(label),
            is.numeric(limit))

  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  url = paste(attr(graph, "root"), "label", label, "nodes", sep = "/")
  param = c(...)
  
  if(length(param) > 1)
    stop("Can only search by one property.")

  if(length(param) == 1)
    url = paste0(url, "?", names(param), "=%22", gsub(" ", "+", param[[1]]), "%22")
  
  if(length(limit) > 0) {
    stopifnot(limit > 0)
    nodes = fromJSON(httpGET(url, httpheader = headers))[1:limit]
  } else {
    nodes = fromJSON(httpGET(url, httpheader = headers))
  }

  if(length(nodes) == 0) {
    message(paste0("No nodes with label ", label, "."))
    return(invisible(NULL))
  }
  
  FUN = function(i) {
    class(nodes[[i]]) = c("entity", "node")
    return(nodes[[i]])
  }
  
  nodes = lapply(1:length(nodes), FUN)
  nodes = lapply(nodes, configure_result)
  return(nodes)
}