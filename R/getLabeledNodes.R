getLabeledNodes = function(graph, .label, ...) UseMethod("getLabeledNodes")

getLabeledNodes.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getLabeledNodes.graph = function(graph, .label, ...) {
  stopifnot(is.character(.label))

  url = paste(attr(graph, "root"), "label", .label, "nodes", sep = "/")
  param = c(...)
  
  if(length(param) > 1)
    stop("Can only search by one property.")

  if(length(param) == 1) {
    url = paste0(url, "?", names(param), "=")
    
    if(is.character(param[[1]])) {
      param[[1]] = URLencode(param[[1]], reserved = TRUE)
      url = paste0(url, "%22", param[[1]], "%22")
    } else if(is.numeric(param[[1]])) {
      url = paste0(url, param[[1]])
    } else if(is.logical(param[[1]])) {
      if(param[[1]]) {
        url = paste0(url, "true")
      } else {
        url = paste0(url, "false")
      }
    } else {
      stop("Property value must be character, numeric, or logical.")
    }
  }

  result = http_request(url, "GET", graph)

  if(length(result) == 0) {
    return(invisible())
  }
  
  nodes = lapply(result, function(r) configure_result(r, attr(graph, "username"), attr(graph, "password"), attr(graph, "auth_token")))
  return(nodes)
}
