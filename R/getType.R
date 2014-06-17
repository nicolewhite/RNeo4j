getType = function(object) UseMethod("getType")

getType.default = function(x) {
  stop("Invalid object. Must supply relationship or graph object.")
}

getType.graph = function(graph) {
  url = attr(graph, "relationship_types")
  response = http_request(url, "GET", "OK")
  result = fromJSON(response)
  return(result)
}

getType.relationship = function(rel) {
  return(attr(rel, "type"))
}