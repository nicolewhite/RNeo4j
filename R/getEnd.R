getEnd = function(rel) UseMethod("getEnd")

getEnd.default = function(x) {
  stop("Invalid object. Must supply a relationship object.")
}

getEnd.relationship = function(rel) {
  node = fromJSON(httpGET(rel$end))
  class(node) = c("entity", "node")
  return(node)
}