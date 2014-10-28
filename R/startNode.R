startNode = function(object) UseMethod("startNode")

startNode.default = function(x) {
  stop("Invalid object. Must supply a relationship or path object.")
}

startNode.relationship = function(rel) {
  url = attr(rel, "start")
  response = http_request(url, "GET", "OK")
  result = fromJSON(response)
  class(result) = c("entity", "node")
  node = configure_result(result, attr(rel, "username"), attr(rel, "password"))
  return(node)
}

startNode.path = function(path) {
  url = attr(path, "start")
  response = http_request(url, "GET", "OK")
  result = fromJSON(response)
  class(result) = c("entity", "node")
  node = configure_result(result, attr(path, "username"), attr(path, "password"))
  return(node)
}