populate = function(graph, data) UseMethod("populate")

populate.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

populate.graph = function(graph, data) {
  stopifnot(is.character(data))
  clear(graph)
  
  if(data == "movies") {
    fpath = system.file("extdata", "movies.txt", package = "Rneo4j")
    
  } else {
    stop("As of now, only the movie dataset is available. Set data = 'movies'.")
  }
  query = readChar(fpath, file.info(fpath)$size)
  suppressMessages(cypher(graph, query))
}

