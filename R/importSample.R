importSample = function(graph, data) UseMethod("importSample")

importSample.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

importSample.graph = function(graph, data) {
  stopifnot(is.character(data))
  clear(graph)
  
  if(data == "movies") {
    addConstraint(graph, "Person", "name")
    addConstraint(graph, "Movie", "title")
    fpath = system.file("extdata", "movies.txt", package = "RNeo4j")
  } else if(data == "dfw") {
    addConstraint(graph, "Terminal", "name")
    addConstraint(graph, "Place", "name")
    addConstraint(graph, "Category", "name")
    fpath = system.file("extdata", "dfw.txt", package = "RNeo4j")
  } else if(data == "caltrain") {
    addConstraint(graph, "Stop", "name")
    addConstraint(graph, "Zone", "id")
    addConstraint(graph, "Train", "id")
    fpath = system.file("extdata", "caltrain.txt", package = "RNeo4j")
  } else if(data == "fleets") {
    addConstraint(graph, "Model", "name")
    addConstraint(graph, "Series", "name")
    addConstraint(graph, "Airline", "name")
    addConstraint(graph, "Country", "name")
    fpath = system.file("extdata", "fleets.txt", package = "RNeo4j")
  } else if(data == "tweets") {
    addConstraint(graph, "Hashtag", "name")
    addConstraint(graph, "Link", "url")
    addConstraint(graph, "Source", "name")
    addConstraint(graph, "Tweet", "id")
    addConstraint(graph, "User", "screen_name")
    fpath = system.file("extdata", "tweets.txt", package = "RNeo4j")
  }
    else {
    stop("Invalid dataset.")
  }
  query = readChar(fpath, file.info(fpath)$size)
  suppressMessages(cypher(graph, query))
}