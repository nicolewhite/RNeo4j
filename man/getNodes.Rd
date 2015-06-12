\name{getNodes}
\alias{getNodes}
\title{Retrieve Nodes with Cypher Queries}
\description{
Deprecated. Use \code{\link{cypherToList}}.

Retrieve nodes from the graph with a Cypher query.
}
\usage{
getNodes(graph, query, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{query}{A Cypher query in the form of a string.}
  \item{...}{Optional parameters to pass to the query in the form key = value, if applicable.}
}
\value{
A list of node objects. Returns NULL if no nodes are found.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

createNode(graph, "Person", name = "Alice", age = 23)
createNode(graph, "Person", name = "Bob", age = 22)
createNode(graph, "Person", name = "Charles", age = 25)

# Query without parameters.
query = "MATCH (p:Person) 
         WHERE p.age < 25 
         RETURN p"

younger_than_25 = getNodes(graph, query)

sapply(younger_than_25, function(p) p$name)

# Query with parameters.
query = "MATCH (p:Person) 
         WHERE p.age > {age} 
         RETURN p"

older_than_22 = getNodes(graph, query, age = 22)

sapply(older_than_22, function(p) p$name)
}
\seealso{
\code{\link{getSingleNode}}
}