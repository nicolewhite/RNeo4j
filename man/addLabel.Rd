\name{addLabel}
\alias{addLabel}
\title{Node Labels}
\description{
Add a label or multiple labels to an existing node object.
}
\usage{
addLabel(node, ...)
}
\arguments{
  \item{node}{A node object to which to add the label(s).}
  \item{...}{The label(s) to add to the node. Accepts a string or strings separated by commas.}
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, name = "Alice")
bob = createNode(graph, name = "Bob")

# Add a single label.
addLabel(alice, "Student")

# Add multiple labels.
addLabel(bob, "Person", "Student")
}
\seealso{
	\code{\link{getLabel}}, \code{\link{dropLabel}}
}