\name{addConstraint}
\alias{addConstraint}
\title{Uniqueness Constraints.}
\description{
Add a uniqueness constraint by label and property key.
}
\usage{
addConstraint(graph, label, key)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label on which to add the uniqueness constraint.}
  \item{key}{The property key that is constrained to be unique.}
}
\details{
A uniqueness constraint cannot be added to a (label, key) pair that already has an index applied. Attempting to add a uniqueness constraint where an index already exists results in an error. Use \code{\link{getIndex}} to view any pre-existing indices. If you wish to have a uniqueness constraint instead of an index, use \code{\link{dropIndex}} to drop the index.
}
\examples{
addConstraint(graph, "Person", "name")
}

