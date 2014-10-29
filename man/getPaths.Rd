\name{getPaths}
\alias{getPaths}
\title{Retrieve Paths with Cypher Queries}
\description{
Retrieve paths from the graph with a Cypher query.
}
\usage{
getPaths(graph, query, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{query}{A Cypher query in the form of a string.}
  \item{...}{Optional parameters to pass to the query in the form key = value, if applicable.}
}
\value{
A list of path objects. Returns NULL if no paths are found.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice", age = 23)
bob = createNode(graph, "Person", name = "Bob", age = 22)
charles = createNode(graph, "Person", name = "Charles", age = 25)

createRel(alice, "KNOWS", bob)
createRel(alice, "KNOWS", charles)

query = "MATCH p = (:Person {name:'Alice'})-[:KNOWS]->(:Person) RETURN p"

paths = getPaths(graph, query)

lapply(paths, startNode)
lapply(paths, endNode)
}
\seealso{
\code{\link{getSinglePath}}
}