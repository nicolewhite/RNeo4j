startGraph = function(url, username = character(), password = character(), auth_token = character(), opts = list()) UseMethod("startGraph")

startGraph.default = function(url, username = character(), password = character(), auth_token=character(), opts = list()) {
  stopifnot(is.character(url), 
            length(url) == 1,
            is.character(username),
            is.character(password),
            is.list(opts))
  
  graph = list()
  
  if(length(username) == 1 && length(password) == 1) {
    attr(graph, "username") = username
    attr(graph, "password") = password
  } else if(length(auth_token == 1)) {
    attr(graph, "auth_token") = auth_token
  } else if(Sys.getenv('NEO4J_AUTH_TOKEN') != "") {
    attr(graph, "auth_token") = Sys.getenv('NEO4J_AUTH_TOKEN')
  }
  
  headers = setHeaders(graph)
  response = http_request(url,"GET","OK", httpheader = headers, addtl_opts = opts)

  result = fromJSON(response)
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
