\name{getSinglePath}
\alias{getSinglePath}
\title{Retrieve Paths with Cypher Queries}
\description{
Deprecated. Use \code{\link{cypherToList}}.

Retrieve a single path from the graph with a Cypher query.
}
\usage{
getSinglePath(graph, query, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{query}{A Cypher query in the form of a string.}
  \item{...}{Optional parameters to pass to the query in the form key = value, if applicable.}
}
\details{
If your Cypher query returns more than one path, you will just arbitrarily get the first path returned. Be sure to order your results by something meaningful and then use \code{LIMIT 1} to ensure you get the path you want.
}
\value{
A path object. Returns NULL if a path is not found.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice", age = 23)
bob = createNode(graph, "Person", name = "Bob", age = 22)
charles = createNode(graph, "Person", name = "Charles", age = 25)

createRel(alice, "KNOWS", bob)
createRel(alice, "KNOWS", charles)

query = "MATCH p = (:Person {name:'Alice'})-[:KNOWS]->(:Person {name:'Bob'}) RETURN p"

path = getSinglePath(graph, query)

startNode(path)
endNode(path)

query = "MATCH p = (:Person {name:'Alice'})-[:KNOWS]->(:Person {name:{name}}) RETURN p"

path = getSinglePath(graph, query, name = "Charles")

endNode(path)
}
\seealso{
\code{\link{getPaths}}
}