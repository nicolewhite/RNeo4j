\name{nodes}
\alias{nodes}
\title{Retrieve Nodes from Paths}
\description{
Retrieve all nodes from a path object.
}
\usage{
nodes(path)
}
\arguments{
  \item{path}{A path object.}
}
\value{
A list of node objects.
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

x = nodes(path)

sapply(x, function(n) n$name)
}
\seealso{
  \code{\link{rels}}
}