\name{endNode}
\alias{endNode}
\title{Retrieve Nodes from Relationships}
\description{
Retrieve the end node from a relationship. This is the node for which the relationship is incoming.
}
\usage{
endNode(rel)
}
\arguments{
  \item{rel}{A relationship object.}
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
}
\seealso{
	\code{\link{startNode}}
}