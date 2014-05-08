startGraph = function(url) UseMethod("startGraph")

startGraph.default = function(url) {
  stopifnot(is.character(url), length(url) == 1)
  graph = fromJSON(httpGET(url))
  graph$root = url
  class(graph) = "graph"
  return(graph)
}

