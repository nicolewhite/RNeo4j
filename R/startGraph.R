#' Connect to the Database
#' 
#' Establish a connection to Neo4j.
#'
#' @param url A character string. The HTTP url. Optional if boltUri is specified.
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
#'
#' graph = startGraph("http://localhost:7474/db/data/",
#'                    username = "neo4j",
#'                    password = "password",
#'                    boltUri = "neo4j://localhost:7687/")
#'
#' graph = startGraph(character(), # only use the Bolt interface
#'                    username = "neo4j",
#'                    password = "password",
#'                    boltUri = "neo4j://localhost:7687/")
#' }
#' 
#' @export
startGraph = function(url, username = character(), password = character(), opts = list(), boltUri = character()) UseMethod("startGraph")

.state = new.env(parent = emptyenv())

#' @export
startGraph.default = function(url = character(), username = character(), password = character(), opts = list(), boltUri = character()) {
  if (is.null(url)) {
    url = character()
  }
  stopifnot(is.character(url),
            is.character(username),
            is.character(password),
            is.list(opts))

  if (length(boltUri) > 0 && !bolt_supported_internal()) {
    warning("RNeo4j built without Bolt support (check build logs for errors), ignoring boltUri")
    boltUri = character()
  }

  if (length(url) == 0 && length(boltUri) != 1) {
    url = "http://localhost:7474/db/data/"
  }

  graph = list()

  if (length(boltUri) == 1) {
    graph$bolt = bolt_begin_internal(boltUri, url, username, password)
  }

  if(length(url) > 0 && length(username) == 1 && length(password) == 1) {
    .state$username = username
    .state$password = password
  }


  .state$opts = opts

  if (length(url) > 0) {
    if(substr(url, nchar(url) - 3, nchar(url)) == "data") {
      url = paste0(url, "/")
    }

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
  }

  graphClass = character()
  if (length(boltUri) == 1) {
    graphClass = c(graphClass, "boltGraph")
  }
  if (length(url) > 0) {
    graphClass = c(graphClass, "graph")
  }
  class(graph) = graphClass

  return(graph)
}
