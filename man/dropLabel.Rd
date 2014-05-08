\name{dropLabel}
\alias{dropLabel}
\title{Labels.}
\description{
Drop a label from a node.
}
\usage{
dropLabel(node, label)
}
\arguments{
  \item{node}{The node object from which to drop the label.}
  \item{label}{The label(s) to be dropped. Accepts one or more strings.}
}
\examples{
dropLabel(alice, "Person", "Student")
dropLabel(bob, "Person")
}