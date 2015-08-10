\name{cypher}
\alias{cypher}
\title{Retrieve Cypher Query Results as a Data Frame}
\description{
Retrieve Cypher query results as a data frame.}
\usage{
cypher(graph, query, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{query}{A Cypher query in the form of a string.}
  \item{...}{Optional parameters to pass to the query in the form key = value, if applicable.}
}
\details{
If returning data, you can only query for tabular results. That is, you can't return node or relationship entities. See \code{\link{cypherToList}} for returning non-tabular data.

Parameters can be passed in individually or as a list, e.g.

\code{cypher(graph, query, key1=value1, key2=value2)}

or

\code{cypher(graph, query, list(key1=value1, key2=value2))}
}
\value{
A data frame. Cypher queries returning no results will return NULL.
}
\seealso{
\code{\link{cypherToList}}
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

# Query without parameters.
cypher(graph, "MATCH n RETURN n.name, n.age")

# Query with parameters.
query = "MATCH n WHERE n.age < {age} RETURN n.name, n.age"
cypher(graph, query, age = 24)

# Query with array parameter.
query = "MATCH n WHERE n.name IN {names} RETURN n.name, n.age"
names = c("Alice", "Charles")
cypher(graph, query, names = names)
	   
# Parameters can be passed as a single list.
query = "MATCH n WHERE n.age > {age1} AND n.age < {age2} RETURN n.name"
cypher(graph, query, list(age1=22, age2=30))
     
# Query that returns a collection.
# The 'friends' column will have lists as values.
query = "MATCH (n)-[:KNOWS]-(m) RETURN n.name, COLLECT(m.name) AS friends, COUNT(m) AS num_friends"
df = cypher(graph, query)
sapply(df, class)
df$friends

# Query that doesn't return anything.
query = "MATCH n SET n.born = {year} - n.age REMOVE n.age"
cypher(graph, query, year = 2014)
cypher(graph, "MATCH n RETURN n.name, n.born")
}