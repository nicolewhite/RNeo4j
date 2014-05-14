getStart = function(rel) UseMethod("getStart")

getStart.default = function(x, ...) {
  stop("Invalid object. Must supply a relationship object.")
}

getStart.relationship = function(rel) {
  result = fromJSON(httpGET(attr(rel, "start")))
  class(result) = c("entity", "node")
  node = configure_result(result)
  return(node)
}