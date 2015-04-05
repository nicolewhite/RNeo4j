allShortestPaths = function(fromNode, relType, toNode, direction = "out", max_depth = 1) UseMethod("allShortestPaths")

allShortestPaths.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

allShortestPaths.node = function(fromNode, relType, toNode, direction = "out", max_depth = 1) {
  return(shortest_path_algo(all=T, 
                            algo="shortestPath", 
                            fromNode=fromNode, 
                            relType=relType, 
                            toNode=toNode, 
                            direction=direction, 
                            max_depth=max_depth))
}