#' Import Sample Datasets
#' 
#' Populate the graph database with one of the sample datasets supplied with this package.
#' 
#' @param graph A graph object.
#' @param data A character string. Datasets include "tweets", "dfw", "caltrain", and "movies".
#' @param input A logical constant. If \code{TRUE}, require confirmation.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' importSample(graph, "tweets")
#' }
#' 
#' @export
importSample = function(graph, data, input = TRUE) UseMethod("importSample")

#' @export
importSample.graph = function(graph, data, input = TRUE) {
  stopifnot(is.character(data))
  clear(graph, input = input)
  
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
  } else {
    stop("Invalid dataset.")
  }
  query = readChar(fpath, file.info(fpath)$size)
  suppressMessages(cypher(graph, query))
}