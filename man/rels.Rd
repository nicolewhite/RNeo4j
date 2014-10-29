\name{rels}
\alias{rels}
\title{Retrieve Relationships from Paths}
\description{
Retrieve all relationships from a path object.
}
\usage{
rels(path)
}
\arguments{
  \item{path}{A path object.}
}
\value{
A list of relationship objects.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, "Person", name = "Bob")
charles = createNode(graph, "Person", name = "Charles")

createRel(alice, "WORKS_WITH", bob)
createRel(bob, "WORKS_WITH", charles)

path = getSinglePath(graph, "MATCH p = (:Person {name:'Alice'})-[:WORKS_WITH*]->(:Person {name:'Charles'}) RETURN p")

x = rels(path)

lapply(x, startNode)
lapply(x, endNode)
}
\seealso{
  \code{\link{nodes}}
}