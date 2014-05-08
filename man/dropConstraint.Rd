\name{dropConstraint}
\alias{dropConstraint}
\title{Uniqueness Constraints.}
\description{
Drop all uniqueness constraints for a given label and property key or for the entire graph database.
}
\usage{
dropConstraint(graph, label = character(), key = character(), all = FALSE)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label for which you want to drop the uniqueness constraint.}
  \item{key}{The key for which you want to drop the uniqueness constraint.}
  \item{all}{Set to TRUE if you want to drop all uniqueness constraints from the graph.}
}
\examples{
# Drop the uniqueness constraint on Person nodes by the name property.
dropConstraint(graph, "Person", "name")

# Drop all uniqueness constraints in the graph database.
dropConstraint(graph, all = TRUE)
}