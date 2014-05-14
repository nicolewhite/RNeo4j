\name{addConstraint}
\alias{addConstraint}
\title{Uniqueness Constraints}
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
A uniqueness constraint cannot be added to a (label, key) pair that already has an index applied. Attempting to add a uniqueness constraint where an index already exists results in an error. Use \code{\link{getIndex}} to view any pre-existing indexes. If you wish to add a uniqueness constraint, use \code{\link{dropIndex}} to drop the index.

Adding a uniqueness constraint will necessarily create an index.

Attempting to add a uniqueness constraint to data that violates the uniqueness constraint results in an error.
}
\examples{
addConstraint(graph, "Person", "name")
}
\seealso{
	\code{\link{getConstraint}}, \code{\link{dropConstraint}}
}
