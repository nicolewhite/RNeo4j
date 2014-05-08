version = function(graph) UseMethod("version")

version.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

version.graph = function(graph) {
  print(graph$neo4j_version)
}
