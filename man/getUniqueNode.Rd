\name{getUniqueNode}
\alias{getUniqueNode}
\title{Retrieve Nodes by Label and Property}
\description{
Retrieve a single node from the graph by specifying its label and unique key = value pair.
}
\usage{
getUniqueNode(graph, .label, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{.label}{A node label. Accepts a string.}
  \item{...}{A key = value pair by which the node label is uniquely constrained. Only accepts one key = value pair.}
}
\value{
A node object. Returns NULL if a node is not found.
}
\details{
A uniqueness constraint must exist on the (label, key) pair in order to use this function. Specify a uniqueness constraint first with \code{\link{addConstraint}}.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

createNode(graph, "Person", name = "Alice")
createNode(graph, "Person", name = "Bob")

addConstraint(graph, "Person", "name")

alice = getUniqueNode(graph, "Person", name = "Alice")
}
\seealso{
\code{\link{getLabeledNodes}}
}