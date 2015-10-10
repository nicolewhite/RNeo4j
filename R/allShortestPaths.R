#' Shortest Paths and Weighted Shortest Paths
#' 
#' Retrieve all the shortest paths between two nodes.
#' 
#' @param fromNode A node object.
#' @param relType A character string. The relationship type to traverse.
#' @param toNode A node object.
#' @param direction A character string. The relationship direction to traverse; this can be either "in", "out", or "all".
#' @param max_depth An integer. The maximum depth of the path.
#' @param cost_property A character string. If retrieving a weighted shortest path, the name of the relationship property that contains the weights.
#' 
#' @return A list of path objects.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice")
#' bob = createNode(graph, "Person", name = "Bob")
#' charles = createNode(graph, "Person", name = "Charles")
#' david = createNode(graph, "Person", name = "David")
#' elaine = createNode(graph, "Person", name = "Elaine")
#' 
#' r1 = createRel(alice, "KNOWS", bob, weight=1.5)
#' r2 = createRel(bob, "KNOWS", charles, weight=2)
#' r3 = createRel(bob, "KNOWS", david, weight=4)
#' r4 = createRel(charles, "KNOWS", david, weight=1)
#' r5 = createRel(alice, "KNOWS", elaine, weight=2)
#' r6 = createRel(elaine, "KNOWS", david, weight=2.5)
#' 
#' # The default max_depth of 1 will not find any paths.
#' # There are no length-1 paths between alice and david.
#' p = allShortestPaths(alice, "KNOWS", david)
#' is.null(p)
#' 
#' # Set the max_depth to 4.
#' p = allShortestPaths(alice, "KNOWS", david, max_depth = 4)
#' n = lapply(p, nodes)
#' lapply(n, function(x) sapply(x, function(y) y$name))
#' 
#' # Setting the direction to "in" and traversing from alice to david will not find a path.
#' p = allShortestPaths(alice, "KNOWS", david, direction = "in", max_depth = 4)
#' is.null(p)
#' 
#' # Setting the direction to "in" and traversing from david to alice will find paths.
#' p = allShortestPaths(david, "KNOWS", alice, direction = "in", max_depth = 4)
#' n = lapply(p, nodes)
#' lapply(n, function(x) sapply(x, function(y) y$name))
#' 
#' # Find all the weighted shortest paths between Alice and David.
#' p = allShortestPaths(alice, "KNOWS", david, cost_property="weight")
#' 
#' p[[1]]$length
#' p[[1]]$weight
#' nodes(p[[1]])
#' 
#' p[[2]]$length
#' p[[2]]$weight
#' nodes(p[[2]])
#' }
#' 
#' @seealso \code{\link{shortestPath}}
#' 
#' @export
allShortestPaths = function(fromNode, 
                            relType, 
                            toNode, 
                            direction = "out", 
                            max_depth = 1,
                            cost_property=character()) {
  UseMethod("allShortestPaths")
}

#' @export
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