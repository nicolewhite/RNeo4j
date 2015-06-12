\name{dijkstra}
\alias{dijkstra}
\title{Retrieve Weighted Shortest Paths}
\description{
Deprecated. Use \code{\link{shortestPath}}.

Retrieve the shortest path between two nodes weighted by a cost property.
}
\usage{
dijkstra(fromNode, 
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
A path object. Returns NULL if a path is not found.
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

p = dijkstra(alice, "KNOWS", david, cost_property="weight")

p$length
p$weight
nodes(p)
}
\seealso{
\code{\link{allDijkstra}}
}