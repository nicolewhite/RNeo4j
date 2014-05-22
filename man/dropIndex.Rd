\name{dropIndex}
\alias{dropIndex}
\title{Indexes}
\description{
Drop index(es) for a given label and property key or for the entire graph database.
}
\usage{
dropIndex(graph, label = character(), key = character(), all = FALSE)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The node label for which to drop the index.}
  \item{key}{The property key for which to drop the index.}
  \item{all}{Set to TRUE to drop all indexes from the graph.}
}
\details{
Dropping a uniqueness constraint necessarily drops the index as well. It is unnecessary to use \code{dropIndex} if \code{\link{dropConstraint}} has already been applied to the same \code{(label, key)} pair.
}
\examples{
# Drop the index on Person nodes by the name property.
dropIndex(graph, "Person", "name")

# Drop all indexes from the graph database.
dropIndex(graph, all = TRUE)
}
\seealso{
	\code{\link{addIndex}}, \code{\link{getIndex}}
}