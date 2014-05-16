\name{dropLabel}
\alias{dropLabel}
\title{Node Labels}
\description{
Drop a label from a node.
}
\usage{
dropLabel(node, label)
}
\arguments{
  \item{node}{The node object from which to drop the label(s).}
  \item{label}{The label(s) to drop from the node. Accepts a single string or strings separated by commas.}
}
\examples{
dropLabel(alice, "Person", "Student")
dropLabel(bob, "Person")
}
\seealso{
	\code{\link{addLabel}}, \code{\link{getLabel}}
}