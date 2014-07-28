\name{outgoingRels}
\alias{outgoingRels}
\title{Retrieve Relationships from Nodes}
\description{
Retreive a list of outgoing relationship objects from a node object, optionally filtering by relationship type.
}
\usage{
outgoingRels(node, ...)
}
\arguments{
	\item{node}{A node object.}
	\item{...}{Optional relationship type(s) by which to filter the results. Accepts a string or strings separated by commas.}
}
\value{
A list of relationship objects.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, "Person", name = "Bob")
charles = createNode(graph, "Person", name = "Charles")
david = createNode(graph, "Person", name = "David")

createRel(alice, "KNOWS", bob)
createRel(alice, "KNOWS", charles)
createRel(charles, "KNOWS", david)

createRel(alice, "WORKS_WITH", david)
createRel(bob, "WORKS_WITH", david)
createRel(bob, "WORKS_WITH", charles)

# Get all outgoing relationships on the bob node.
bob_outgoing = outgoingRels(bob)

# Get the end nodes of all outgoing relationships.
ends = lapply(bob_outgoing, endNode)

sapply(ends, function(e) e$name)

# Get all outgoing "KNOWS" relationships on the alice node.
alice_outgoing_knows = outgoingRels(alice, "KNOWS")

# Get the end nodes of all outgoing "KNOWS" relationships.
ends = lapply(alice_outgoing_knows, endNode)

sapply(ends, function(e) e$name)
}
\seealso{
\code{\link{incomingRels}}
}