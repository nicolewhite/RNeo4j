\name{cypherToList}
\alias{cypherToList}
\title{Retrieve Cypher Query Results as a List}
\description{
Retrieve Cypher query results as a list.
}
\usage{
cypherToList(graph, query, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{query}{A Cypher query in the form of a string.}
  \item{...}{Optional parameters to pass to the query in the form key = value, if applicable.}
}
\value{
A list. Cypher queries returning no results will return NULL.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice", age = 23)
bob = createNode(graph, "Person", name = "Bob", age = 22)
charles = createNode(graph, "Person", name = "Charles", age = 25)
david = createNode(graph, "Person", name = "David", age = 20)

createRel(alice, "KNOWS", bob)
createRel(alice, "KNOWS", charles)
createRel(charles, "KNOWS", david)

cypherToList(graph, "MATCH n RETURN n, n.age")
     
cypherToList(graph, "MATCH (n)-[:KNOWS]-(m) RETURN n, COLLECT(m) AS friends, COUNT(m) AS num_friends")

cypherToList(graph, "MATCH p = (n)-[:KNOWS]-(m) RETURN p")
}