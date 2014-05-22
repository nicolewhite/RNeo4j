\name{dropConstraint}
\alias{dropConstraint}
\title{Uniqueness Constraints}
\description{
Drop uniqueness constraint(s) for a given label and property key or for the entire graph database.
}
\usage{
dropConstraint(graph, label = character(), key = character(), all = FALSE)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The node label for which to drop the uniqueness constraint.}
  \item{key}{The property key for which to drop the uniqueness constraint.}
  \item{all}{Set to TRUE to drop all uniqueness constraints from the graph.}
}
\examples{
# Drop the uniqueness constraint on Person nodes by the name property.
dropConstraint(graph, "Person", "name")

# Drop all uniqueness constraints from the graph database.
dropConstraint(graph, all = TRUE)
}
\seealso{
	\code{\link{addConstraint}}, \code{\link{getConstraint}}
}