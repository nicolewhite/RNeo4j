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
  \item{node}{The node object from which to drop the label(s).}
  \item{...}{The label(s) to drop from the node. Accepts a single string or strings separated by commas.}
}
\examples{
# Drop the Person label from the alice node.
dropLabel(alice, "Person")

# Drop the Person and Student labels from the bob node.
dropLabel(bob, "Person", "Student")
}
\seealso{
	\code{\link{addLabel}}, \code{\link{getLabel}}
}