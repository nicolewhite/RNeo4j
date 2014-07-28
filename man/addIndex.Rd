\name{addIndex}
\alias{addIndex}
\title{Indexes}
\description{
Add an index to a node label and property key.
}
\usage{
addIndex(graph, label, key)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{A node label on which to add the index. Accepts a string.}
  \item{key}{A property key by which the label will be indexed. Accepts a string.}
}
\details{
An index already exists for any (label, key) pair that has a uniqueness constraint applied. Attempting to add an index where a uniqueness constraint already exists results in an error. Use \code{\link{getConstraint}} to view any pre-existing uniqueness constraints. If a uniqueness constraint already exists for the (label, key) pair, then it must be true that the index exists as well; adding an index is unnecessary.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

createNode(graph, "Person", name = "Nicole", status = "Employed")
createNode(graph, "Person", name = "Drew", status = "Employed")
createNode(graph, "Person", name = "Aaron", status = "Unemployed")

addIndex(graph, "Person", "status")
}
\seealso{
	\code{\link{getIndex}}, \code{\link{dropIndex}}
}
