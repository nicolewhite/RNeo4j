getType = function(object) UseMethod("getType")

getType.default = function(x) {
  stop("Invalid object. Must supply relationship or graph object.")
}

getType.graph = function(graph) {
  url = attr(graph, "relationship_types")
  result = fromJSON(httpGET(url))
  return(result)
}

getType.relationship = function(rel) {
  return(attr(rel, "type"))
}