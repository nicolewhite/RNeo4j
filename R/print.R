print.graph = function(graph) {
  cat("< Graph Object > \n")
  invisible(lapply(names(graph), function(x) {print(graph[x])}))
}

summary.graph = function(graph) {
  query = "MATCH (a)-[r]->(b) RETURN DISTINCT head(labels(a)) AS This, type(r) as To, head(labels(b)) AS That"
  df = suppressMessages(cypher(graph, query))
  print(df)
}

print.node = function(node) {
  cat("< Node Object > \n")
  if(any(!is.na(names(node)))) {
    invisible(lapply(names(node), function(x) {print(node[x])}))
  }
}

print.relationship = function(rel) {
  cat("< Relationship Object > \n")
  if(any(!is.na(names(rel)))) {
    invisible(lapply(names(rel), function(x) {print(rel[x])}))
  }
}

print.path = function(path) {
  cat("< Path Object > \n")
  if(any(!is.na(names(path)))) {
    invisible(lapply(names(path), function(x) {print(path[x])}))
  }
}