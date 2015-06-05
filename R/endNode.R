endNode = function(object) UseMethod("endNode")

endNode.default = function(x) {
  stop("Invalid object. Must supply a relationship or path object.")
}

endNode.relationship = function(rel) {
  url = attr(rel, "end")
  result = http_request(url, "GET", rel)
  node = configure_result(result, attr(rel, "username"), attr(rel, "password"), attr(rel, "auth_token"))
  return(node)
}

endNode.path = function(path) {
  url = attr(path, "end")
  result = http_request(url, "GET", path)
  node = configure_result(result, attr(path, "username"), attr(path, "password"), attr(path, "auth_token"))
  return(node)
}