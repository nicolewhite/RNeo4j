\name{startNode}
\alias{startNode}
\title{Retrieve Nodes from Relationships or Paths}
\description{
Retrieve the start node from a relationship or path object.
}
\usage{
startNode(object)
}
\arguments{
  \item{object}{A relationship or path object.}
}
\value{
A node object.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, "Person", name = "Bob")

rel = createRel(alice, "WORKS_WITH", bob)

startNode(rel)

query = "
MATCH p = (a:Person)-[:WORKS_WITH]->(b:Person)
WHERE a.name = 'Alice' AND b.name = 'Bob'
RETURN p
"

path = getSinglePath(graph, query)

startNode(path)
}
\seealso{
	\code{\link{endNode}}
}