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
If returning data, you can only query for tabular results. That is, this method has no current functionality for Cypher results containing array properties, collections, nodes, or relationships.

You can send Cypher queries without any return values (i.e., a Cypher query without the word \code{RETURN} in it).
}
\value{
A data frame. Cypher queries returning no results will return NULL.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

createNode(graph, name = "Alice", age = 23)
createNode(graph, name = "Bob", age = 22)
createNode(graph, name = "Charles", age = 25)

# Query without parameters.
cypher(graph, "MATCH n RETURN n.name, n.age")

# Query with parameters.
cypher(graph, 
	   "MATCH n WHERE n.age < {age} RETURN n.name, n.age", 
	   age = 24)

# Query with array parameter.
names = c("Alice", "Charles")
cypher(graph,
	   "MATCH n WHERE n.name IN {names} RETURN n.name, n.age",
	   names = names)

# Query that doesn't return anything.
cypher(graph, 
	   "MATCH n SET n.born = {year} - n.age REMOVE n.age",
	   year = 2014)

cypher(graph, 'MATCH n RETURN n.name, n.born')
}