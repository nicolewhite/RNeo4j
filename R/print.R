print.graph = function(graph) {
  invisible(lapply(names(graph), function(x) {print(graph[x])}))
}

summary.graph = function(graph) {
  query = "MATCH (a)-[r]->(b) RETURN DISTINCT head(labels(a)) AS This, type(r) as To, head(labels(b)) AS That"
  df = suppressMessages(cypher(graph, query))
  print(df)
}

print.node = function(node) {
#   cat("Labels: ")
#   cat(getLabel(node))
#   cat("\n\n")
  invisible(lapply(names(node), function(x) {print(node[x])}))
}

print.relationship = function(rel) {
#   cat("Start node:\n")
#   print(startNode(rel))
#   cat("\n")
#   cat("Relationship type:\n")
#   print(attr(rel, "type"))
#   cat("\n")
#   cat("End node:\n")
#   print(endNode(rel))
#   cat("\n")
#   cat("Relationship properties:\n")
  invisible(lapply(names(rel), function(x) {print(rel[x])}))
}