#' Relationships
#' 
#' Create a relationship between two nodes with the given type and properties.
#' 
#' @param .fromNode A node object.
#' @param .relType A character string.
#' @param .toNode A node object.
#' @param ... A named list. Relationship properties in the form key = value.
#' 
#' @return A relationship object.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice")
#' bob = createNode(graph, "Person", name = "Bob")
#' charles = createNode(graph, "Person", name = "Charles")
#' 
#' createRel(alice, "WORKS_WITH", bob)
#' createRel(bob, "KNOWS", charles, since = 2000, through = "Work")
#' 
#' props = list(since = 2001, through = "School")
#' createRel(alice, "KNOWS", charles, props)
#' }
#' 
#' @export
createRel = function(.fromNode, .relType, .toNode, ...) {
  UseMethod("createRel")
}

#' @export
createRel.node = function(.fromNode, .relType, .toNode, ...) {
  stopifnot(is.character(.relType), 
            "node" %in% class(.toNode))
  
  fields = list(to = attr(.toNode, "self"), type = .relType)
  dots = list(...)
  params = parse_dots(dots)
  
  if(length(params) > 0) {
    fields = c(fields, data = list(params)) 
  }
    
  url = attr(.fromNode, "create_relationship")
  result = http_request(url, "POST", fields)
  rel = configure_result(result)
  return(rel)
}

createRel.boltNode = function(.fromNode, .relType, .toNode, ...) {
  stopifnot("boltNode" %in% class(.toNode))

  graph = attr(.fromNode, "boltGraph")
  query = paste0("MATCH (a),(b) WHERE ID(a)={a} AND ID(b)={b} CREATE (a)-[r:`", .relType, "`]->(b) RETURN r")
  return(cypherToList(graph, query, a=.fromNode, b=.toNode, relType=.relType)[[1]]$r)
}