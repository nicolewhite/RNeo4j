\name{getSingleNode}
\alias{getSingleNode}
\title{Retrieve Nodes with Cypher Queries}
\description{
Deprecated. Use \code{\link{cypherToList}}.

Retrieve a single node from the graph with a Cypher query.
}
\usage{
getSingleNode(graph, query, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{query}{A Cypher query in the form of a string.}
  \item{...}{Optional parameters to pass to the query in the form key = value, if applicable.}
}
\details{
If your Cypher query returns more than one node, you will just arbitrarily get the first node returned. Be sure to order your results by something meaningful and then use \code{LIMIT 1} to ensure you get the node you want.
}
\value{
A node object. Returns NULL if a node is not found.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

createNode(graph, "Person", name = "Alice", age = 23)
createNode(graph, "Person", name = "Bob", age = 22)
createNode(graph, "Person", name = "Charles", age = 25)

# Query without parameters.
query = "MATCH (p:Person)
		 WITH p
		 ORDER BY p.age DESC
		 RETURN p 
		 LIMIT 1"
		 
oldest = getSingleNode(graph, query)

# Query with parameters.
query = "MATCH (p:Person {name:{name}}) 
         RETURN p"

alice = getSingleNode(graph, query, name = "Alice")
}
\seealso{
\code{\link{getNodes}}
}