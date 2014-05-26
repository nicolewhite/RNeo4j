\name{getLabel}
\alias{getLabel}
\title{Node Labels}
\description{
Get all node labels for a given node object or for the entire graph database.
}
\usage{
getLabel(object)
}
\arguments{
  \item{object}{An object for which to view all node labels. Accepts a node or graph object (see details).}
}
\value{
A character vector.
}
\details{
Supplying a node object returns all node labels for the given node. Supplying a graph object returns all node labels in the graph. 
}
\examples{
alice = createNode(graph, name = "Alice")
bob = createNode(graph, name = "Bob")

addLabel(alice, "Student")
addLabel(bob, "Person", "Student")

# View all labels on the alice node.
getLabel(alice)

# [1] "Student"

# View all node labels in the graph database.
getLabel(graph)

# [1] "Student" "Person"
}
\seealso{
	\code{\link{addLabel}}, \code{\link{dropLabel}}
}