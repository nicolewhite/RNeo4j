\name{getRelByCypher}
\alias{getRelByCypher}
\title{Retrieving Nodes from the Graph.}
\description{
Retrieve a relationship object from the graph with a Cypher query.
}
\usage{
getRelByCypher(graph, query)
}
\arguments{
  \item{graph}{A graph object.}
  \item{query}{A Cypher string.}
}
\details{
If your Cypher query returns more than one relationship, you will just arbitrarily get the first node. Be sure to order your results by something meaningful and then use \code{LIMIT 1} to ensure you get the node you want.
}
\value{
A relationship object.
}
\examples{
query = "MATCH (:Person {name:'Tom Hanks'})-[a:ACTED_IN]->(:Movie {title:'Cloud Atlas'}) 
         RETURN a LIMIT 1"
		 
rel = getRelByCypher(graph, query)
}