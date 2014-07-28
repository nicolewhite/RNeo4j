\name{Transactions}
\alias{Transactions}
\alias{newTransaction}
\alias{appendCypher}
\alias{commit}

\title{Transactional Endpoint}

\description{
Send Cypher queries through the transactional endpoint.
}

\usage{
newTransaction(graph)
appendCypher(transaction, query, ...)
commit(transaction)
}

\arguments{
\item{graph}{A graph object.}
\item{transaction}{A transaction object.}
\item{query}{A Cypher query in the form of a string.}
\item{...}{Optional parameters to pass to the query in the form key = value, if applicable.}
}

\details{
As of now, there is no functionality for returning data from the transactional endpoint.
}

\value{
\code{newTransaction} returns a transaction object. Both \code{appendCypher} and \code{commit} return NULL.
}

\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

data = data.frame(Origin = c("SFO", "AUS", "MCI"),
                  FlightNum = c(1, 2, 3),
                  Destination = c("PDX", "MCI", "LGA"))


query = "
MERGE (origin:Airport {name:{origin_name}})
MERGE (destination:Airport {name:{dest_name}})
CREATE (origin)<-[:ORIGIN]-(:Flight {number:{flight_num}})-[:DESTINATION]->(destination)
"

t = newTransaction(graph)

for (i in 1:nrow(data)) {
  origin_name = data[i, ]$Origin
  dest_name = data[i, ]$Dest
  flight_num = data[i, ]$FlightNum
  
  appendCypher(t, 
               query, 
               origin_name = origin_name, 
               dest_name = dest_name, 
               flight_num = flight_num)
}

commit(t)

cypher(graph, "MATCH (o:Airport)<-[:ORIGIN]-(f:Flight)-[:DESTINATION]->(d:Airport)
               RETURN o.name, f.number, d.name")
}