\name{getLabel}
\alias{getLabel}
\title{Node Labels}
\description{
View all node labels for a given node object or for the entire graph database.
}
\usage{
getLabel(object)
}
\arguments{
  \item{object}{The object for which to view all node labels. Accepts a node object or a graph object (see details).}
}
\value{
A character vector.
}
\details{
Supplying a graph object returns all node labels in the graph database. Supplying a node object returns all node labels for the given node.
}
\examples{
# View all labels on the alice node.
getLabel(alice)

# View all node labels in the graph database.
getLabel(graph)
}
\seealso{
	\code{\link{addLabel}}, \code{\link{dropLabel}}
}