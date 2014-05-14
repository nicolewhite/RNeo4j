\name{getNodeByIndex}
\alias{getNodeByIndex}
\title{Retrieving Nodes from the Graph}
\description{
Retrieve a node object from the graph by specifying its label and indexed (key = value) pair.
}
\usage{
getNodeByIndex(graph, label, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label of the node.}
  \item{...}{A key = value pair by which the label is indexed. Only accepts one key = value pair.}
}
\value{
A node object.
}
\details{
If you have not specified a uniqueness constraint for the label and property, you will arbitrarily get the first node found with the given label and property value. It is suggested that you specify a uniqueness constraint first with \code{\link{addConstraint}}.
}
\examples{
alice = getNodeByIndex(graph, "Person", name = "Alice")
}