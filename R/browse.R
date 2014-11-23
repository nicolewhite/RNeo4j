browse = function(graph, ...) UseMethod("browse", graph)

browse.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

browse.graph = function(graph) {
  if (Sys.getenv("RSTUDIO") == "1") {
    rstudio::viewer(sub("db/data", "browser", attr(graph, "root")))
  } else {
    browseURL(sub("db/data", "browser", attr(graph, "root")))
  }
}
