\name{getNodeByCypher}
\alias{getNodeByCypher}
\title{Retrieving Nodes from the Graph.}
\description{
Retrieve a node object from the graph with a Cypher query.
}
\usage{
getNodeByCypher(graph, query)
}
\arguments{
  \item{graph}{A graph object.}
  \item{query}{A Cypher string.}
}
\details{
If your Cypher query returns more than one node, you will just arbitrarily get the first node. Be sure to order your results by something meaningful and then use \code{LIMIT 1} to ensure you get the node you want.
}
\value{
A node object.
}
\examples{
query = "MATCH n 
		 WITH n 
		 ORDER BY n.age 
		 RETURN n 
		 LIMIT 1"
		 
youngest = getNodeByCypher(graph, query)
}