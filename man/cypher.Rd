\name{cypher}
\alias{cypher}
\title{Cypher Queries.}
\description{
Get Cypher results as a data frame. Send a query
with or without parameters.}
\usage{
cypher(graph, query = character(), ...)
}
\arguments{
  \item{graph}{The graph object you want to query.}
  \item{query}{The Cypher query in the form of a string.}
  \item{...}{Parameters to pass to the query, if applicable.}
}
\details{
If returning data, you can only query for tabular results. That is, this method has no current functionality for Cypher results containing array properties, collections, nodes, or relationships.

You can send Cypher queries without any return values (i.e., a Cypher query without the word \code{RETURN} in it) for initial data import (i.e., \code{CREATE} statements).
}
\value{
A data frame. Cypher queries returning no results will return NULL.
}
\examples{
# Query without parameters.
df = cypher(graph, "MATCH n RETURN n.name, n.age")

# Query that requires parameters.
df = cypher(graph, "MATCH (n {name:{name}}) RETURN n.name, n.age", name = "Alice")

# Query that doesn't return anything.
cypher(graph, "CREATE (n:Person {name:'Nicole'})")
}