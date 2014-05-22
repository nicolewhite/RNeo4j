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
  \item{node}{The node object to which to add the label(s).}
  \item{...}{The label(s) to add to the node. Accepts a string or strings separated by commas.}
}
\examples{
# Add a single label.
addLabel(bob, "Student")

# Add multiple labels.
addLabel(alice, "Person", "Student")
}
\seealso{
	\code{\link{getLabel}}, \code{\link{dropLabel}}
}