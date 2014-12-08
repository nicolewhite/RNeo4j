ingest <- function(network, ...) UseMethod("ingest", network)

ingest.default = function(x, ...) {
  stop("Invalid object. Must supply network type object.")
}


ingest.igraph = function(network, how, domain = NULL) {
  
  if (is.null(domain)) domain <- deparse(substitute(network))
  
  nodes <- as.data.frame(vertex.attributes(network))
  nodes$domain <- domain
  
  name <- list()
  for (i in 1:nrow(nodes)) {
    name[[i]] <- do_call(createNode, quote(graph), as.list(nodes[i, ]))
  }  
  
  n <- sapply(name, `[[`, 'name')
  
  edges <- as.data.frame(get.edgelist(network))
  edges <- cbind(edges, as.data.frame(edge.attributes(network)), domain = domain)
  
  for (i in 1:nrow(edges)) {
    from <- name[which(edges$V1[i] == n)][[1]]
    to <- name[which(edges$V2[i] == n)][[1]]
    do_call(createRel, quote(from), how, quote(to), as.list(edges[i, -c(1, 2)]))
    if (!is.directed(karate)) {
      do_call(createRel, quote(to), how, quote(from), as.list(edges[i, -c(1, 2)]))
    }
  }
  return(invisible(NULL))
}



