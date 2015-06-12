\name{allDijkstra}
\alias{allDijkstra}
\title{Retrieve Weighted Shortest Paths}
\description{
Deprecated. Use \code{\link{allShortestPaths}}.

Retrieve all the shortest paths between two nodes weighted by a cost property.
}
\usage{
allDijkstra(fromNode, 
            relType, 
            toNode,
            cost_property,
            direction = "out")
}
\arguments{
  \item{fromNode}{A node object.}
  \item{relType}{The relationship type to traverse. Accepts a string.}
  \item{toNode}{A node object.}
  \item{cost_property}{The name of the relationship property that contains the weights. Accepts a string.}
  \item{direction}{The relationship direction to traverse. Accepts "in" or "out".}
}
\value{
A list of path objects. Returns NULL if no paths are found.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, "Person", name = "Bob")
charles = createNode(graph, "Person", name = "Charles")
david = createNode(graph, "Person", name = "David")
elaine = createNode(graph, "Person", name = "Elaine")

r1 = createRel(alice, "KNOWS", bob, weight=1.5)
r2 = createRel(bob, "KNOWS", charles, weight=2)
r3 = createRel(bob, "KNOWS", david, weight=4)
r4 = createRel(charles, "KNOWS", david, weight=1)
r5 = createRel(alice, "KNOWS", elaine, weight=2)
r6 = createRel(elaine, "KNOWS", david, weight=2.5)

p = allDijkstra(alice, "KNOWS", david, cost_property="weight")

p[[1]]$length
p[[1]]$weight
nodes(p[[1]])

p[[2]]$length
p[[2]]$weight
nodes(p[[2]])
}
\seealso{
\code{\link{dijkstra}}
}