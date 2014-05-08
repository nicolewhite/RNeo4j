clear = function(graph) UseMethod("clear")

clear.default = function(x) {
  stop("Invalid object. Must supply a graph object.")
}

clear.graph = function(graph) {
  print("You are about to delete all nodes, relationships, and indices from the graph database. Are you sure? Y/N")
  answer = scan(what = character(), nmax = 1, quiet = TRUE)
  
  if(answer == "Y") {
    suppressMessages(dropIndex(graph))
    query = "MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r"
    cypher(graph, query)
    
  } else if(answer == "N") {
    stop("Delete aborted.")
  }
  else {
    stop("You must answer Y or N.")
  }
}