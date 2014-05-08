\name{addLabel}
\alias{addLabel}
\title{Labels.}
\description{
Enables you to add a label to an existing node object.
}
\usage{
addLabel(node, label)
}
\arguments{
  \item{node}{The node object to which you want to add a label.}
  \item{label}{The label(s) you want to add to the node. Accepts a single string or a vector of strings.}
}
\examples{
addLabel(alice, c("Person", "Student"))
}