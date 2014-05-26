\name{dropLabel}
\alias{dropLabel}
\title{Node Labels}
\description{
Drop label(s) from a node.
}
\usage{
dropLabel(node, ...)
}
\arguments{
  \item{node}{A node object from which to drop the given label(s).}
  \item{...}{The label(s) to drop from the node. Accepts a single string or strings separated by commas.}
}
\examples{
alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, c("Person", "Student"), name = "Bob")

# Drop the Person label from the alice node.
dropLabel(alice, "Person")

alice

# Labels: 
# No labels on the node.
#
# $name
# [1] "Alice"

# Drop the Person and Student labels from the bob node.
dropLabel(bob, "Person", "Student")

bob

# Labels: 
# No labels on the node.
#
# $name
# [1] "Bob"
}
\seealso{
	\code{\link{addLabel}}, \code{\link{getLabel}}
}