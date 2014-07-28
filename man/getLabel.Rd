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
  \item{object}{An object for which to get all node labels. Accepts a node or graph object (see details).}
}
\value{
A character vector.
}
\details{
Supplying a node object returns all node labels for the given node. Supplying a graph object returns all node labels in the graph. 
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, name = "Alice")
bob = createNode(graph, name = "Bob")

addLabel(alice, "Student")
addLabel(bob, "Person", "Student")

# View all labels on the alice node.
getLabel(alice)

# View all node labels in the graph database.
getLabel(graph)
}
\seealso{
	\code{\link{addLabel}}, \code{\link{dropLabel}}
}