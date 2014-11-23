browse = function(graph, ...) UseMethod("browse", graph)

browse.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

browse.graph = function(graph, viewer = FALSE) {
  if (Sys.getenv("RSTUDIO") == "1" & viewer) {
    rstudio::viewer(sub("db/data", "browser", attr(graph, "root")))
  } else {
    browseURL(sub("db/data", "browser", attr(graph, "root")))
  }
}
