\name{getIndex}
\alias{getIndex}
\title{Indexing}
\description{
View all indexes for a given label or for the entire graph database.
}
\usage{
getIndex(graph, label = character())
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label for which you want to see all indexes.}
}
\value{
A data frame. Returns NULL if no indexes are found.
}
\details{
Supplying only a graph object as an argument returns all indexes in the graph database.
}
\examples{
# Get all indexes for the Person label.
getIndex(graph, "Person")

# Get all indexes in the graph.
getIndex(graph)
}
\seealso{
	\code{\link{addIndex}}, \code{\link{dropIndex}}
}