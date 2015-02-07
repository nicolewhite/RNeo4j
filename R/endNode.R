endNode = function(object) UseMethod("endNode")

endNode.default = function(x) {
  stop("Invalid object. Must supply a relationship or path object.")
}

endNode.relationship = function(rel) {
  url = attr(rel, "end")
  headers = setHeaders(rel)
  response = http_request(url, "GET", "OK", httpheader=headers)
  result = fromJSON(response)
  class(result) = c("entity", "node")
  node = configure_result(result, attr(rel, "username"), attr(rel, "password"), attr(rel, "auth_token"))
  return(node)
}

endNode.path = function(path) {
  url = attr(path, "end")
  headers = setHeaders(path)
  response = http_request(url, "GET", "OK", httpheader=headers)
  result = fromJSON(response)
  class(result) = c("entity", "node")
  node = configure_result(result, attr(path, "username"), attr(path, "password"), attr(path, "auth_token"))
  return(node)
}