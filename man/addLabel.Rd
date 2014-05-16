\name{addLabel}
\alias{addLabel}
\title{Node Labels}
\description{
Enables you to add a label or multiple labels to an existing node object.
}
\usage{
addLabel(node, ...)
}
\arguments{
  \item{node}{The node object to which to add the label(s).}
  \item{...}{The label(s) to add to the node. Accepts a single string or strings separated by commas.}
}
\examples{
addLabel(alice, "Person", "Student")
}
\seealso{
	\code{\link{getLabel}}, \code{\link{dropLabel}}
}