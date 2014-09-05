browse = function(graph) UseMethod("browse")

browse.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

browse.graph = function(graph) {
  browseURL(sub("db/data", "browser", attr(graph, "root")))
}