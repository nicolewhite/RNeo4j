\name{getNodeByIndex}
\alias{getNodeByIndex}
\title{Retrieving Nodes from the Graph.}
\description{
Retrieve a node object from the graph by specifying its label and indexed (key, value) pair.
}
\usage{
getNodeByIndex(graph, label, key, value)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label of the node object.}
  \item{key}{The property key by which the label is indexed.}
  \item{value}{The value of the property key.}
}
\value{
A node object.
}
\examples{
alice = getNodeByIndex(graph, "Person", "name", "Alice")
}