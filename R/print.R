print.graph = function(graph) {
  query = "MATCH (a)-[r]->(b) RETURN DISTINCT head(labels(a)) AS This, type(r) as To, head(labels(b)) AS That"
  df = suppressMessages(cypher(graph, query))
  print(df)
}

print.node = function(node) {
  cat("Labels: ")
  cat(getLabel(node))
  cat("\n\n")
  print(node$data)
}

print.relationship = function(rel) {
  cat("Start node:\n")
  print(getStart(rel))
  cat("\n")
  cat("End node:\n")
  print(getEnd(rel))
  cat("\n")
  cat("Relationship properties:\n")
  print(rel$data)
}