endNode = function(rel) UseMethod("endNode")

endNode.default = function(x) {
  stop("Invalid object. Must supply a relationship object.")
}

endNode.relationship = function(rel) {
  url = attr(rel, "end")
  response = http_request(url, "GET", "OK")
  result = fromJSON(response)
  class(result) = c("entity", "node")
  node = configure_result(result, attr(rel, "username"), attr(rel, "password"))
  return(node)
}