startNode = function(object) UseMethod("startNode")

startNode.default = function(x) {
  stop("Invalid object. Must supply a relationship or path object.")
}

startNode.relationship = function(rel) {
  url = attr(rel, "start")
  result = http_request(url, "GET", rel)
  node = configure_result(result, attr(rel, "username"), attr(rel, "password"), attr(rel, "auth_token"))
  return(node)
}

startNode.path = function(path) {
  url = attr(path, "start")
  result = http_request(url, "GET", path)
  node = configure_result(result, attr(path, "username"), attr(path, "password"), attr(path, "auth_token"))
  return(node)
}