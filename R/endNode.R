endNode = function(rel) UseMethod("endNode")

endNode.default = function(x) {
  stop("Invalid object. Must supply a relationship object.")
}

endNode.relationship = function(rel) {
  result = fromJSON(httpGET(attr(rel, "end")))
  class(result) = c("entity", "node")
  node = configure_result(result)
  return(node)
}