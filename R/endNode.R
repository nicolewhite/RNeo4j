endNode = function(object) UseMethod("endNode")

endNode.default = function(x) {
  stop("Invalid object. Must supply a relationship or path object.")
}

endNode.relationship = function(rel) {
  url = attr(rel, "end")
  response = http_request(url, "GET", "OK")
  result = fromJSON(response)
  class(result) = c("entity", "node")
  node = configure_result(result, attr(rel, "username"), attr(rel, "password"))
  return(node)
}

endNode.path = function(path) {
  url = attr(path, "end")
  response = http_request(url, "GET", "OK")
  result = fromJSON(response)
  class(result) = c("entity", "node")
  node = configure_result(result, attr(path, "username"), attr(path, "password"))
  return(node)
}