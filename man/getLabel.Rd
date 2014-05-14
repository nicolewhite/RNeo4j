\name{getLabel}
\alias{getLabel}
\title{Labels}
\description{
Get all labels on a graph or node object.
}
\usage{
getLabel(object)
}
\arguments{
  \item{object}{The object for which you want to view all labels. Supplying a graph object returns all labels in the database. Supplying a node object returns all labels for the given node.}
}
\value{
A character vector.
}
\examples{
# View all labels in the graph database.
getLabel(graph)

# View all labels on the Alice node.
getLabel(alice)
}
\seealso{
	\code{\link{addLabel}}, \code{\link{dropLabel}}
}