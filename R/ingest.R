
ingest <- function(network, ...) UseMethod("ingest", network)

ingest.default = function(x, ...) {
  stop("Invalid object. Must supply network type object.")
}


ingest.igraph = function(network, how, domain = NULL) {
  # Add some domain info if nothing was passed.
  if (is.null(domain)) domain <- deparse(substitute(network))
  
  # Capture the node attributes in a data frame.
  nodes <- as.data.frame(vertex.attributes(network))
  nodes$domain <- domain
  
  # Add all of the nodes to the database.
  name <- list()
  for (i in 1:nrow(nodes)) {
    name[[i]] <- do_call(createNode, quote(graph), as.list(nodes[i, ]))
  }  
  
  # Capture all of the imformation about edges, both incident vertices and attributes.
  edges <- as.data.frame(get.edgelist(network))
  edges <- cbind(edges, as.data.frame(edge.attributes(network)), domain = domain)
  
  # Capture the name given to a node.
  n <- sapply(name, `[[`, 'name')
  
  # Add the edges to the database.
  for (i in 1:nrow(edges)) {
    # Find the incedent nodes from the list of nodes.
    from <- name[which(edges$V1[i] == n)][[1]]
    to <- name[which(edges$V2[i] == n)][[1]]
    
    do_call(createRel, quote(from), how, quote(to), as.list(edges[i, -c(1, 2)]))
    # If the network is undirected add the reverse edge.
    if (!is.directed(karate)) {
      do_call(createRel, quote(to), how, quote(from), as.list(edges[i, -c(1, 2)]))
    }
  }
  return(invisible(NULL))
}



