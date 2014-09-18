\name{getOrCreateNode}
\alias{getOrCreateNode}
\title{Create Unique Node or Retrieve Unique Node}
\description{
Create a unique node or retrieve it if it already exists.
}
\usage{
getOrCreateNode(graph, .label, ...)
}
\arguments{
	\item{graph}{A graph object.}
	\item{.label}{A node label. Accepts a string.}
	\item{...}{Node properties in the form key = value, separated by commas. The first key = value pair listed must be the uniquely constrained key = value pair for the given node label.}
}
\value{
A node object.
}
\details{
A uniqueness constraint must exist for the given node label and first key = value pair listed in \code{...}. Use \code{\link{addConstraint}} to add a uniqueness constraint.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

createNode(graph, "Person", name = "Alice", age = 24)
createNode(graph, "Person", name = "Bob", age = 21)

addConstraint(graph, "Person", "name")

# Alice is retrieved from the graph; a new node is not created.
alice = getOrCreateNode(graph, "Person", name = "Alice")

# Additional properties listed after the unique key = value 
# pair are ignored if the node is retrieved instead of
# created.
bob = getOrCreateNode(graph, "Person", name = "Bob", age = 22)

# Node doesn't exist, so it is created.
charles = getOrCreateNode(graph, "Person", name = "Charles")

# There are now three nodes in the graph.
length(getLabeledNodes(graph, "Person"))
}