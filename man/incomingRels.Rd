\name{incomingRels}
\alias{incomingRels}
\title{Retrieve Relationships from Nodes}
\description{
Retreive a list of incoming relationship objects from a node object, optionally filtering by relationship type.
}
\usage{
incomingRels(node, ...)
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

# Get all incoming relationships on the david node.
david_incoming = incomingRels(david)

sapply(david_incoming, getType)

# Get the start nodes of all incoming relationships.
starts = lapply(david_incoming, startNode)

sapply(starts, function(s) s$name)

# Get all incoming "WORKS_WITH" relationships on the charles node.
charles_incoming_works = incomingRels(charles, "WORKS_WITH")

# Get the start nodes of all incoming "WORKS_WITH" relationships.
starts = lapply(charles_incoming_works, startNode)

sapply(starts, function(s) s$name)
}
\seealso{
\code{\link{outgoingRels}}
}