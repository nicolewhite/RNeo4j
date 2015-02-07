nodes = function(path) UseMethod("nodes")

nodes.default = function(x, ...) {
  stop("Invalid object. Must supply path object.")
}

nodes.path = function(path) {
  urls = attr(path, "nodes")
  header = setHeaders(path)
  FUN <- function(x) {
    url = x
    response = http_request(url, "GET", "OK", httpheader=header)
    result = fromJSON(response)
    class(result) = c("entity", "node")
    node = configure_result(result, attr(path, "username"), attr(path, "password"), attr(path, "auth_token"))
    return(node)
  }
  nodes = lapply(urls, FUN)
  return(nodes)
}