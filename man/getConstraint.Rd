\name{getConstraint}
\alias{getConstraint}
\title{Uniqueness Constraints}
\description{
Get all uniqueness constraints for a given label or for the entire graph database.
}
\usage{
getConstraint(graph, label = character())
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{A node label for which to view all uniqueness constraints. Accepts a string.}
}
\value{
A data frame. Returns NULL if no constraints are found.
}
\details{
Supplying only a graph object as an argument returns all uniqueness constraints in the graph database.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, "Person", name = "Bob")

san_fran = createNode(graph, "City", name = "San Francisco")
austin = createNode(graph, "City", name = "Austin")

addConstraint(graph, "Person", "name")
addConstraint(graph, "City", "name")

# Get all uniqueness constraints on Person nodes.
getConstraint(graph, "Person")

# Get all uniqueness constraints in the graph database.
getConstraint(graph)
}
\seealso{
	\code{\link{addConstraint}}, \code{\link{dropConstraint}}
}