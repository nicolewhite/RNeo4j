populate = function(graph, data) UseMethod("populate")

populate.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

populate.graph = function(graph, data) {
  stopifnot(is.character(data))
  clear(graph)
  
  if(data == "movies") {
    load('data/movies.Rdata')
  } else {
    stop("Only the movie dataset is available. Set data = 'movies'.")
  }
  
  cypher(graph, query)
  return(invisible(NULL))
}