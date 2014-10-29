\name{shortestPath}
\alias{shortestPath}
\title{Retrieve Shortest Paths}
\description{
Retrieve the shortest path between two nodes.
}
\usage{
shortestPath(fromNode, 
             relType, 
             toNode, 
             direction = "out", 
             max_depth = 1)
}
\arguments{
  \item{fromNode}{A node object.}
  \item{relType}{The relationship type to traverse. Accepts a string.}
  \item{toNode}{A node object.}
  \item{direction}{The relationship direction to traverse. Accepts "in" or "out".}
  \item{max_depth}{The maximum depth of the path. Accepts an integer.}
}
\value{
A path object. Returns NULL if no path is found.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, "Person", name = "Bob")
charles = createNode(graph, "Person", name = "Charles")
david = createNode(graph, "Person", name = "David")
elaine = createNode(graph, "Person", name = "Elaine")

createRel(alice, "WORKS_WITH", bob)
createRel(bob, "WORKS_WITH", charles)
createRel(charles, "WORKS_WITH", david)
createRel(alice, "WORKS_WITH", elaine)
createRel(elaine, "WORKS_WITH", david)

# The default max_depth of 1 will not find a path.
# There are no length-1 paths between alice and david.
p = shortestPath(alice, "WORKS_WITH", david)
is.null(p)

# Set the max_depth to 4.
p = shortestPath(alice, "WORKS_WITH", david, max_depth = 4)
p$length
n = nodes(p)
sapply(n, function(x) x$name)

# Setting the direction to "in" and traversing from alice to david will not find a path.
p = shortestPath(alice, "WORKS_WITH", david, direction = "in", max_depth = 4)
is.null(p)

# Setting the direction to "in" and traversing from david to alice will find a path.
p = shortestPath(david, "WORKS_WITH", alice, direction = "in", max_depth = 4)
p$length
n = nodes(p)
sapply(n, function(x) x$name)
}
\seealso{
\code{\link{allShortestPaths}}
}