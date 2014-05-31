startGraph = function(url) UseMethod("startGraph")

startGraph.default = function(url) {
  stopifnot(is.character(url), length(url) == 1)
  result = fromJSON(httpGET(url))
  
  graph = list()
  graph$version = result$neo4j_version
  attr(graph, "node") = result$node
  attr(graph, "node_index") = result$node_index
  attr(graph, "relationship_index") = result$relationship_index
  attr(graph, "relationship_types") = result$relationship_types
  attr(graph, "batch") = result$batch
  attr(graph, "cypher") = result$cypher
  attr(graph, "indexes") = result$indexes
  attr(graph, "constraints") = result$constraints
  attr(graph, "node_labels") = result$node_labels
  
  # Remove trailing forward slash.
  url = substr(url, 1, nchar(url) - 1)
  attr(graph, "root") = url
    
  class(graph) = "graph"
  return(graph)
}

