shortestPath = function(fromNode, relType, toNode, direction = "out", max_depth = 1) UseMethod("shortestPath")

shortestPath.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

shortestPath.node = function(fromNode, relType, toNode, direction = "out", max_depth = 1) {
  return(shortest_path_algo(all=F, 
                            algo="shortestPath", 
                            fromNode=fromNode, 
                            relType=relType, 
                            toNode=toNode, 
                            direction=direction, 
                            max_depth=max_depth))
}