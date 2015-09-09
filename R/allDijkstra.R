#' Weighted Shortest Paths
#' 
#' Deprecated. Use \code{\link{allShortestPaths}}. Retrieve all the shortest paths between two nodes weighted by a cost property.
#' 
#' @param fromNode A node object.
#' @param relType A character string. The relationship type to traverse.
#' @param toNode A node object.
#' @param direction A character string. The relationship direction to traverse. Should be "in" or "out".
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
#' p = allDijkstra(alice, "KNOWS", david, cost_property="weight")
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
#' @seealso \code{\link{dijkstra}}
#' 
#' @export
allDijkstra = function(fromNode, relType, toNode, cost_property = character(), direction = "out") UseMethod("allDijkstra")

#' @export
allDijkstra.node = function(fromNode, relType, toNode, cost_property, direction = "out") {
  return(shortest_path_algo(all=T, 
                            algo="dijkstra", 
                            fromNode=fromNode, 
                            relType=relType, 
                            toNode=toNode, 
                            direction=direction, 
                            cost_property=cost_property))
}