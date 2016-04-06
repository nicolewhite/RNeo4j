#' Connect to the Database
#' 
#' Establish a connection to Neo4j.
#' 
#' @param url A character string.
#' @param username A character string. If authentication is enabled, your username.
#' @param password A character string. If authentication is enabled, your password.
#' @param opts A named list. Optional HTTP settings.
#' 
#' @return A graph object.
#' 
#' @examples
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' 
#' graph = startGraph("http://localhost:7474/db/data/", 
#'                    username = "neo4j",
#'                    password = "password")
#' 
#' graph = startGraph("http://localhost:7474/db/data/", 
#'                    opts = list(timeout=3))
#' }
#' 
#' @export
startGraph = function(url, username = character(), password = character(), opts = list()) UseMethod("startGraph")

.state = new.env(parent = emptyenv())

#' @export
startGraph.default = function(url, username = character(), password = character(), opts = list()) {
  stopifnot(is.character(url), 
            length(url) == 1,
            is.character(username),
            is.character(password),
            is.list(opts))
  
  if(substr(url, nchar(url) - 3, nchar(url)) == "data") {
    url = paste0(url, "/")
  }
  
  graph = list()
  
  if(length(username) == 1 && length(password) == 1) {
    .state$username = username
    .state$password = password
  }
  
  .state$opts = opts
  
  result = http_request(url, "GET")

  graph$version = result$neo4j_version
  attr(graph, "node") = paste0(url, "node")
  attr(graph, "node_index") = paste0(url, "index/node")
  attr(graph, "relationship_index") = paste0(url, "index/relationship")
  attr(graph, "relationship_types") = paste0(url, "relationship/types")
  attr(graph, "batch") = paste0(url, "batch")
  attr(graph, "cypher") = paste0(url, "cypher")
  attr(graph, "indexes") = paste0(url, "schema/index")
  attr(graph, "constraints") = paste0(url, "schema/constraint")
  attr(graph, "node_labels") = paste0(url, "labels")
  attr(graph, "transaction") = paste0(url, "transaction")
  attr(graph, "opts") = opts
  
  root = substr(url, 1, nchar(url) - 1)
  attr(graph, "root") = root
  
  class(graph) = "graph"
  return(graph)
}
