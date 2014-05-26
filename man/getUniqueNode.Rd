\name{getUniqueNode}
\alias{getUniqueNode}
\title{Retrieve Nodes from the Graph Database by Label and Property}
\description{
Retrieve a single node from the graph by specifying its label and unique key = value pair.
}
\usage{
getUniqueNode(graph, label, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{A node label. Accepts a string.}
  \item{...}{A key = value pair by which the node label is uniquely constrained. Only accepts one key = value pair.}
}
\value{
A node object. Returns NULL if a node is not found.
}
\details{
A uniqueness constraint must exist on the (label, key) pair in order to use this function. Specify a uniqueness constraint first with \code{\link{addConstraint}}.
}
\examples{
createNode(graph, "Person", name = "Alice")
createNode(graph, "Person", name = "Bob")

addConstraint(graph, "Person", "name")

alice = getUniqueNode(graph, "Person", name = "Alice")

alice

# Labels: Person
#
# $name
# [1] "Alice"
}
\seealso{
\code{\link{getLabeledNodes}}
}