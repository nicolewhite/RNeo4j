#' @export
print.graph = function(x, ...) {
  cat("< Graph > \n")
  invisible(lapply(names(x), function(y) {print(x[y])}))
}

#' @export
print.boltGraph = print.graph;

#' @export
summary.graph = function(object, ...) {
  query = "MATCH (a)-[r]->(b) RETURN DISTINCT head(labels(a)) AS This, type(r) as To, head(labels(b)) AS That"
  df = suppressMessages(cypher(object, query))
  print(df)
}

#' @export
summary.boltGraph = summary.graph;

#' @export
print.node = function(x, ...) {
  cat("< Node > \n")
  cat(getLabel(x))
  cat("\n\n")
  if(suppressWarnings(any(!is.na(names(x))))) {
    invisible(lapply(names(x), function(y) {print(x[y])}))
  }
}

#' @export
print.boltNode = print.node;

#' @export
print.relationship = function(x, ...) {
  cat("< Relationship > \n")
  cat(getType(x))
  cat("\n\n")
  if(suppressWarnings(any(!is.na(names(x))))) {
    invisible(lapply(names(x), function(y) {print(x[y])}))
  }
}

#' @export
print.boltRelationship = print.relationship;

#' @export
print.neopath = function(x, ...) {
  cat("< Path > \n")
  if(suppressWarnings(any(!is.na(names(x))))) {
    invisible(lapply(names(x), function(y) {print(x[y])}))
  }
}

#' @export
print.boltPath = print.neopath;
