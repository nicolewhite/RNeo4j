clear = function(graph, input = TRUE) UseMethod("clear")

clear.default = function(x, ...) {
  stop("Invalid object. Must supply a graph object.")
}

clear.graph = function(graph, input = TRUE) {
  stopifnot(is.logical(input))
  
  if(input == FALSE) {
    answer = "Y"
  } else{
    message("You are about to delete all nodes, relationships, indexes, and constraints from the graph database. Are you sure? Y/N")
    answer = scan(what = character(), nmax = 1, quiet = TRUE)
  }

  if(answer == "Y") {
    suppressMessages(dropConstraint(graph, all = TRUE))
    suppressMessages(dropIndex(graph, all = TRUE))
    query = "MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r"
    suppressMessages(cypher(graph, query))
    
  } else if(answer == "N") {
    stop("Delete aborted.")
  }
  else {
    stop("You must answer Y or N.")
  }
}