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
  \item{label}{A node label for which to drop the uniqueness constraint. Accepts a string.}
  \item{key}{A property key for which to drop the uniqueness constraint. Accepts a string.}
  \item{all}{Set to TRUE to drop all uniqueness constraints from the graph.}
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

createNode(graph, "Person", name = "Alice")
createNode(graph, "Person", name = "Bob")

createNode(graph, "City", name = "San Francisco")
createNode(graph, "City", name = "Austin")

addConstraint(graph, "Person", "name")
addConstraint(graph, "City", "name")

getConstraint(graph)

# Drop the uniqueness constraint on Person nodes by the name property.
dropConstraint(graph, "Person", "name")

getConstraint(graph)

# Drop all uniqueness constraints from the graph database.
dropConstraint(graph, all = TRUE)

getConstraint(graph)
}
\seealso{
	\code{\link{addConstraint}}, \code{\link{getConstraint}}
}