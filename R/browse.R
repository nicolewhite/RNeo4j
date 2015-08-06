browse = function(graph, ...) UseMethod("browse", graph)

browse.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

browse.graph = function(graph, viewer = TRUE) {
  url <- sub("db/data", "browser", attr(graph, "root"))
  if (Sys.getenv("RSTUDIO") == "1" & viewer & grepl('localhost', url)) {
    if('rstudio' %in% names(installed.packages()[, 1])) {
      rstudio::viewer(url)
    } else {
      rstudioapi::viewer(url)
    }
  } else {
    browseURL(url)
  }
}
