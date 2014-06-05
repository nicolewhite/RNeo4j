degreeMatrix = function(graph, label, key, type, direction = character()) UseMethod("degreeMatrix")

degreeMatrix.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

degreeMatrix.graph = function(graph, label, key, type, direction = character()) {
  stopifnot(is.character(label),
            length(label) == 1,
            is.character(key),
            length(key) == 1,
            is.character(type),
            length(type) == 1,
            is.character(direction),
            key %in% getConstraint(graph, label)$property_keys)
  
  vars = configure_vars(label, key, type, direction)
  
  label = vars[[1]]
  key = vars[[2]]
  type = vars[[3]]
  inc = vars[[4]]
  out = vars[[5]]
  
  query = paste0("MATCH (n",
                 label,
                 ") OPTIONAL MATCH p = (n",
                 inc,
                 type,
                 out,
                 label,
                 ")")
  
  query = paste0(query, 
                 " RETURN n.", 
                 key, 
                 " AS node, CASE WHEN p IS NOT NULL THEN COUNT(p) ELSE 0 END AS degree ORDER BY node")
  
  mat = cypher(graph, query)
  mat = data.frame(mat[1], mat[1], mat[2])
  mat = reshape(mat, 
                idvar = "node", 
                timevar = "node.1", 
                direction = "wide")
  rownames(mat) = mat$node
  mat = mat[-1]
  mat[is.na(mat)] = 0
  colnames(mat) = sub("degree.", "", colnames(mat))
  mat = as.matrix(mat)
  return(mat)
}