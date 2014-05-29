\name{incomingRels}
\alias{incomingRels}
\title{Retrieve Relationships from Nodes}
\description{
Retreive a list of incoming relationship objects from a node object, optionally filtering by relationship type.
}
\usage{
incomingRels(node, ..., limit = numeric())
}
\arguments{
	\item{node}{A node object.}
	\item{...}{Optional relationship type(s) by which to filter the results. Accepts a string or strings separated by commas.}
	\item{limit}{An optional numeric value to limit how many relationships are returned.}
}
\value{
A list of relationship objects.
}
\examples{
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

# [1] "WORKS_WITH" "WORKS_WITH" "KNOWS"

# Get the start nodes of all incoming relationships.
starts = lapply(david_incoming, startNode)

sapply(starts, function(s) s$name)

# [1] "Alice" "Bob" "Charles"

# Get all incoming "WORKS_WITH" relationships on the charles node.
charles_incoming_works = incomingRels(charles, "WORKS_WITH")

# Get the start nodes of all incoming "WORKS_WITH" relationships.
starts = lapply(charles_incoming_works, startNode)

sapply(starts, function(s) s$name)

# [1] "Bob"
}
\seealso{
\code{\link{outgoingRels}}
}