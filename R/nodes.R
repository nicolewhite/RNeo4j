nodes = function(path) UseMethod("nodes")

nodes.default = function(x, ...) {
  stop("Invalid object. Must supply path object.")
}

nodes.path = function(path) {
  urls = attr(path, "nodes")
  FUN <- function(x) {
    url = x
    response = http_request(url, "GET", "OK")
    result = fromJSON(response)
    class(result) = c("entity", "node")
    node = configure_result(result, attr(path, "username"), attr(path, "password"))
    return(node)
  }
  nodes = lapply(urls, FUN)
  return(nodes)
}