#' Import Sample Datasets
#' 
#' Populate the graph database with one of the sample datasets supplied with this package.
#' 
#' @param graph A graph object.
#' @param data A character string.
#' @param input A logical constant. If \code{TRUE}, require confirmation.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' importSample(graph, "movies")
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
  } else {
    stop("Invalid dataset.")
  }
  query = readChar(fpath, file.info(fpath)$size)
  suppressMessages(cypher(graph, query))
}