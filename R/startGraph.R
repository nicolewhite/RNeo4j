#' Connect to the Database
#' 
#' Establish a connection to Neo4j.
#' 
#' @param url A character string.
#' @param username A character string. If authentication is enabled, your username.
#' @param password A character string. If authentication is enabled, your password.
#' @param opts A named list. Optional HTTP settings.
#' @param boltUri A character string. The bolt URI. Optionally enables the Bolt interface for Cypher.
#'
#' @return A graph object.
#' 
#' @examples
#' \dontrun{
#' graph = startGraph() # http://localhost:7474/db/data/ by default
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
startGraph = function(url, username = character(), password = character(), opts = list(), boltUri = character()) UseMethod("startGraph")

.state = new.env(parent = emptyenv())

#' @export
startGraph.default = function(url = character(), username = character(), password = character(), opts = list(), boltUri = character()) {
  stopifnot(is.character(url),
            is.character(username),
            is.character(password),
            is.list(opts))
  if (length(url) == 0) {
    url = "http://localhost:7474/db/data/"
  }
  
  if(substr(url, nchar(url) - 3, nchar(url)) == "data") {
    url = paste0(url, "/")
  }

  graph = list()

  if (length(boltUri) == 1) {
    graph$bolt = bolt_begin_internal(boltUri, username, password)
  }

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

  if (length(boltUri) == 1) {
    class(graph) = c("boltGraph", "graph")
  } else {
    class(graph) = "graph"
  }

  return(graph)
}
