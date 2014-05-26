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
alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, "Person", name = "Bob")

rel = createRel(alice, "works with", bob)

endNode(rel)

# Labels: Person
#
# $name
# [1] "Bob"
}
\seealso{
	\code{\link{startNode}}
}