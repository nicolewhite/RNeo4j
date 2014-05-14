getEnd = function(rel) UseMethod("getEnd")

getEnd.default = function(x) {
  stop("Invalid object. Must supply a relationship object.")
}

getEnd.relationship = function(rel) {
  result = fromJSON(httpGET(attr(rel, "end")))
  class(result) = c("entity", "node")
  node = configure_result(result)
  return(node)
}