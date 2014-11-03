\name{endNode}
\alias{endNode}
\title{Retrieve Nodes from Relationships or Paths}
\description{
Retrieve the end node from a relationship or path object.
}
\usage{
endNode(object)
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

endNode(rel)

query = "
MATCH p = (a:Person)-[:WORKS_WITH]->(b:Person)
WHERE a.name = 'Alice' AND b.name = 'Bob'
RETURN p
"

path = getSinglePath(graph, query)

endNode(path)
}
\seealso{
	\code{\link{startNode}}
}