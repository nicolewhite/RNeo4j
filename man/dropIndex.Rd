\name{dropIndex}
\alias{dropIndex}
\title{Indexes}
\description{
Drop an index for a given label and property key or for the entire graph database.
}
\usage{
dropIndex(graph, label = character(), key = character(), all = FALSE)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label for which you want to drop the index.}
  \item{key}{The property key for which you want to drop the index.}
  \item{all}{Set to TRUE if you want to drop all indexes from the graph.}
}
\details{
Uniqueness constraints must be dropped before an index can be dropped. Use \code{\link{dropConstraint}} to drop a constraint.
}
\examples{
# Drop the index for the name property on Person nodes.
dropIndex(graph, "Person", "name")

# Drop all indexes in the graph.
dropIndex(graph, all = TRUE)
}
\seealso{
	\code{\link{addIndex}}, \code{\link{getIndex}}
}