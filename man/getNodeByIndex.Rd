\name{getNodeByIndex}
\alias{getNodeByIndex}
\title{Retrieving Nodes from the Graph.}
\description{
Retrieve a node object from the graph by specifying its label and indexed (key, value) pair.
}
\usage{
getNodeByIndex(graph, label, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label of the node object.}
  \item{...}{A key = value pair by which the label is indexed. Only accepts one key = value pair.}
}
\value{
A node object.
}
\details{
If you have not specified a uniqueness constraint for the label and property, you will arbitrarily get the first node found with the given label and property value. It is suggested you specify a uniqueness constraint first. However, a uniqueness constraint cannot be added when an index already exists for the label and property. The index must be dropped first. Use \code{\link{dropIndex}} to drop an index and \code{\link{addConstraint}} to add a uniqueness constraint (which also adds an index).
}
\examples{
alice = getNodeByIndex(graph, "Person", name = "Alice")
}