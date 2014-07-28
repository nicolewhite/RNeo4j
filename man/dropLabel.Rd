\name{dropLabel}
\alias{dropLabel}
\title{Node Labels}
\description{
Drop label(s) from a node.
}
\usage{
dropLabel(node, ..., all = FALSE)
}
\arguments{
  \item{node}{A node object from which to drop the given label(s).}
  \item{...}{The label(s) to drop from the node. Accepts a single string or strings separated by commas.}
  \item{all}{Set to TRUE to drop all labels from the node.}
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, c("Person", "Student"), name = "Bob")

# Drop the Person label from the alice node.
dropLabel(alice, "Person")

# Drop all labels from the bob node.
dropLabel(bob, all = TRUE)
}
\seealso{
	\code{\link{addLabel}}, \code{\link{getLabel}}
}