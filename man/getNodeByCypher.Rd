\name{getNodeByCypher}
\alias{getNodeByCypher}
\title{Retrieve Nodes from the Graph Database}
\description{
Retrieve a node object from the graph database with a Cypher query.
}
\usage{
getNodeByCypher(graph, query, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{query}{A Cypher query in the form of a string.}
  \item{...}{Optional parameters to pass to the query in the form of key = value, if applicable.}
}
\details{
If your Cypher query returns more than one node, you will just arbitrarily get the first node returned. Be sure to order your results by something meaningful and then use \code{LIMIT 1} to ensure you get the node you want.
}
\value{
A node object.
}
\examples{
# Query without parameters.
query = "MATCH (p:Person)
		 WITH p
		 ORDER BY p.born 
		 RETURN p 
		 LIMIT 1"
		 
oldest = getNodeByCypher(graph, query)

# Query with parameters.
query = "MATCH (m:Movie {title:{title}}) RETURN m"

cloudatlas = getNodeByCypher(graph, query, title = "Cloud Atlas")
}