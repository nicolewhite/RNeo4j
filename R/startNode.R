startNode = function(rel) UseMethod("startNode")

startNode.default = function(x, ...) {
  stop("Invalid object. Must supply a relationship object.")
}

startNode.relationship = function(rel) {
  url = attr(rel, "start")
  response = http_request(url, "GET", "OK")
  result = fromJSON(response)
  class(result) = c("entity", "node")
  node = configure_result(result)
  return(node)
}