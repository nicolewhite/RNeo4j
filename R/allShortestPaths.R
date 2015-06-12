allShortestPaths = function(fromNode, 
                            relType, 
                            toNode, 
                            direction = "out", 
                            max_depth = 1,
                            cost_property=character()) {
  UseMethod("allShortestPaths")
}

allShortestPaths.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

allShortestPaths.node = function(fromNode, 
                                 relType, 
                                 toNode, 
                                 direction = "out", 
                                 max_depth = 1, 
                                 cost_property=character()) {
  
  algo = ifelse(length(cost_property) > 0, "dijkstra", "shortestPath")
  
  return(shortest_path_algo(all=T, 
                            algo=algo, 
                            fromNode=fromNode, 
                            relType=relType, 
                            toNode=toNode, 
                            direction=direction, 
                            max_depth=max_depth,
                            cost_property=cost_property))
}