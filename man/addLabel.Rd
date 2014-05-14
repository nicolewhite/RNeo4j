\name{addLabel}
\alias{addLabel}
\title{Labels}
\description{
Enables you to add a label or multiple labels to an existing node object.
}
\usage{
addLabel(node, ...)
}
\arguments{
  \item{node}{The node object to which you want to add a label.}
  \item{...}{The label(s) you want to add to the node. Accepts a single string or strings separated by commas.}
}
\examples{
addLabel(alice, "Person", "Student")
}
\seealso{
	\code{\link{getLabel}}, \code{\link{dropLabel}}
}