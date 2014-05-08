getStart = function(rel) UseMethod("getStart")

getStart.default = function(x) {
  stop("Invalid object. Must supply a relationship object.")
}

getStart.relationship = function(rel) {
  node = fromJSON(httpGET(rel$start))
  class(node) = c("entity", "node")
  return(node)
}