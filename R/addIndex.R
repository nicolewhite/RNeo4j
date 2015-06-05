addIndex = function(graph, label, key) UseMethod("addIndex")

addIndex.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

addIndex.graph = function(graph, label, key) {
  stopifnot(is.character(label), 
            is.character(key),
            length(label) == 1,
            length(key) == 1)
  
  field = list(property_keys = key)
  url = paste(attr(graph, "indexes"), label, sep = "/")
  http_request(url,
               "POST",
               graph,
               field)
  return(invisible())
}
