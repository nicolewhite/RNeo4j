getOrCreateNode = function(graph, .label, ...) UseMethod("getOrCreateNode")

getOrCreateNode.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getOrCreateNode.graph = function(graph, .label, ...) {
  stopifnot(is.character(.label))
  
  props = c(...)
  
  if(!(names(props)[1] %in% getConstraint(graph, .label)$property_keys)) {
    stop("The first key = value pair listed in ... must be uniquely constrained for the given node label.")
  }
            
  node = try(createNode(graph, .label, ...), TRUE)
  
  if("try-error" %in% class(node)) {
    node = getUniqueNode(graph, .label, props[1])
  }
  
  return(node)
}