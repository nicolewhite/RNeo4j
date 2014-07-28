\name{addConstraint}
\alias{addConstraint}
\title{Uniqueness Constraints}
\description{
Add a uniqueness constraint to a label and property key.
}
\usage{
addConstraint(graph, label, key)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{A node label on which to add the uniqueness constraint. Accepts a string.}
  \item{key}{A property key by which the label will be uniquely constrained. Accepts a string.}
}
\details{
A uniqueness constraint cannot be added to a (label, key) pair that already has an index applied. Attempting to add a uniqueness constraint where an index already exists results in an error. Use \code{\link{getIndex}} to view any pre-existing indexes. If you wish to add a uniqueness constraint, use \code{\link{dropIndex}} to drop the index.

Adding a uniqueness constraint will necessarily create an index.

Attempting to add a uniqueness constraint to data that violates the uniqueness constraint results in an error.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

createNode(graph, "Person", name = "Alice")
createNode(graph, "Person", name = "Bob")

addConstraint(graph, "Person", "name")
}
\seealso{
	\code{\link{getConstraint}}, \code{\link{dropConstraint}}
}
