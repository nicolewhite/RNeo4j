\name{getRelByCypher}
\alias{getRelByCypher}
\title{Retrieve Relationships from the Graph}
\description{
Retrieve a relationship object from the graph with a Cypher query.
}
\usage{
getRelByCypher(graph, query, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{query}{A Cypher query in the form of a string.}
  \item{...}{Parameters to pass to the query, if applicable.}
}
\details{
If your Cypher query returns more than one relationship, you will just arbitrarily get the first relationship returned. Be sure that you are specific enough to get the relationship you want.
}
\value{
A relationship object.
}
\examples{
# No parameters.
query = "MATCH (:Person {name:'Tom Hanks'})-[a:ACTED_IN]->(:Movie {title:'Cloud Atlas'}) 
         RETURN a"
		 
rel = getRelByCypher(graph, query)

# Parameters.
query = "MATCH (:Person {name:{name}})-[a:ACTED_IN]->(:Movie {title:{title}})
		 RETURN a"

rel = getRelByCypher(graph, query, name = "Tom Hanks", title = "Cloud Atlas")
}
\seealso{
	\code{\link{getStart}}, \code{\link{getEnd}}
}