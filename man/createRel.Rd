\name{createRel}
\alias{createRel}
\title{Create Relationships}
\description{
Create a relationship between two nodes with the given type and properties.
}
\usage{
createRel(.fromNode, .relType, .toNode, ...)
}
\arguments{
  \item{.fromNode}{A node object from which the relationship will be outgoing.}
  \item{.relType}{A relationship type in the form of a string.}
  \item{.toNode}{A node object to which the relationship will be incoming.}
  \item{...}{Optional relationship properties in the form key = value (separated by commas).}
}
\value{
A relationship object.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, "Person", name = "Bob")
charles = createNode(graph, "Person", name = "Charles")

# Relationship without properties.
createRel(alice, "WORKS_WITH", bob)

# Relationship with properties.
createRel(bob, "KNOWS", charles, since = 2000, through = "Work")
}
\seealso{
\code{\link{startNode}}, \code{\link{endNode}}
}