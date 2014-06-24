adjacencyMatrix = function(graph, label, key, type, direction = character()) UseMethod("adjacencyMatrix")

adjacencyMatrix.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

adjacencyMatrix.graph = function(graph, label, key, type, direction = character()) {
  stopifnot(is.character(label),
            length(label) == 1,
            is.character(key),
            length(key) == 1,
            is.character(type),
            length(type) == 1,
            is.character(direction))
  
  if(!(key %in% getConstraint(graph, label)$property_keys)) {
    stop("A uniqueness constraint needs to be applied to label '", label, "' with key '", key, "'.")
  }
  
  vars = configure_vars(label, key, type, direction)
  
  label = vars[[1]]
  key = vars[[2]]
  type = vars[[3]]
  inc = vars[[4]]
  out = vars[[5]]
  
  query = paste0("MATCH (n1",
                 label,
                 "), (n2",
                 label,
                 ")",
                 " OPTIONAL MATCH p = (n1",
                 inc,
                 type,
                 out,
                 "n2)")
  
  query = paste0(query, 
                 " RETURN n1.", key, " AS node1, n2.", key, " AS node2,",
                 " CASE WHEN p IS NOT NULL THEN 1 ELSE 0 END AS adj")
  
  mat = cypher(graph, query)
  
  mat = reshape(mat, 
                idvar = "node1", 
                timevar = "node2", 
                direction = "wide")
  
  rownames(mat) = mat$node1
  mat = mat[-1]
  colnames(mat) = sub("adj.", "", colnames(mat))
  mat = as.matrix(mat)
  return(mat)
}