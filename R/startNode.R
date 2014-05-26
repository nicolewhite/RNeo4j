startNode = function(rel) UseMethod("startNode")

startNode.default = function(x, ...) {
  stop("Invalid object. Must supply a relationship object.")
}

startNode.relationship = function(rel) {
  result = fromJSON(httpGET(attr(rel, "start")))
  class(result) = c("entity", "node")
  node = configure_result(result)
  return(node)
}