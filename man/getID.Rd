\name{getID}
\alias{getID}
\title{Internal ID of Nodes and Relationships}
\description{
Retrieve the internal ID of a node or relationship object.
}
\usage{
getID(object)
}
\arguments{
	\item{object}{The object for which to retrieve the internal ID. Accepts a node or relationship object.}
}
\value{
An integer.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, "Person", name = "Bob")
charles = createNode(graph, "Person", name = "Charles")

getID(alice)

nodes = getNodes(graph, "MATCH n RETURN n")

sapply(nodes, getID)
}