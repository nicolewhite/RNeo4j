\name{getIndex}
\alias{getIndex}
\title{Indexes}
\description{
View all indexes for a given label or for the entire graph database.
}
\usage{
getIndex(graph, label = character())
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label for which to view all indexes.}
}
\value{
A data frame. Returns NULL if no indexes are found.
}
\details{
Supplying only a graph object as an argument returns all indexes in the graph database.
}
\examples{
# View all indexes on the Person node label.
getIndex(graph, "Person")

# View all indexes in the graph database.
getIndex(graph)
}
\seealso{
	\code{\link{addIndex}}, \code{\link{dropIndex}}
}