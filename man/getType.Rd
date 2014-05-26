\name{getType}
\alias{getType}
\title{Relationship Types}
\description{
Get the type of a relationship object.
}
\usage{
getType(object)
}
\arguments{
	\item{object}{The object for which to view the relationship type(s). Accepts a relationship or graph object (see details).}
}
\value{
A string or character vector.
}
\details{
Supplying a relationship object returns the type of the relationship as a string. Supplying a graph object returns all relationship types in the graph as a character vector. 
}
\examples{
alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, "Person", name = "Bob")
charles = createNode(graph, "Person", name = "Charles")

createRel(bob, "WORKS_WITH", charles)
rel = createRel(alice, "KNOWS", bob)

# Get the type of a relationship object.
getType(rel)

# [1] "KNOWS"

# Get all relationship types in the graph.
getType(graph)

# [1] "KNOWS" "WORKS_WITH"
}