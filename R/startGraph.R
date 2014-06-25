startGraph = function(url, username = character(), password = character()) UseMethod("startGraph")

startGraph.default = function(url, username = character(), password = character()) {
  stopifnot(is.character(url), 
            length(url) == 1,
            is.character(username),
            is.character(password))
  
  if(length(username) == 1 && length(password) == 1) {
    userpwd = paste0(username, ":", password)
    url = gsub("http://", paste0("http://", userpwd, "@"), url)
    response = http_request(url,"GET","OK")
    
  } else {
    response = http_request(url,"GET","OK")
  }
  
  result = fromJSON(response)
  graph = list()
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
  
  # Remove trailing forward slash.
  url = substr(url, 1, nchar(url) - 1)
  attr(graph, "root") = url
  
  if(length(username) == 1 && length(password) == 1) {
    attr(graph, "username") = username
    attr(graph, "password") = password
  }
  
  class(graph) = "graph"
  return(graph)
}

