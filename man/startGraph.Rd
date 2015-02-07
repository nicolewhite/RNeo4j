\name{startGraph}
\alias{startGraph}
\title{Connect to the Database}
\description{
Establish a connection to the graph database.
}
\usage{
startGraph(url, 
           username = character(), 
           password = character(),
           auth_token = character(),
           opts = list())
}
\arguments{
  \item{url}{The URL of the graph database. Accepts a string.}
  \item{username}{If the database is remote, your username. Accepts a string.}
  \item{password}{If the database is remote, your password. Accepts a string.}
  \item{auth_token}{If on Neo4j 2.2 and above, your authentication token. Accepts a string.}
  \item{opts}{Optional HTTP settings.}
}
\value{
A graph object.
}
\examples{
# A local db.
graph = startGraph("http://localhost:7474/db/data/")

# A remote graphene db.
graph = startGraph(url = "http://test.sb02.stations.graphenedb.com:24789/db/data/", 
                   username = "test", 
                   password = "ftDPkChL641gBe5s9xBO")
                   
# A Neo4j 2.2 db.
graph = startGraph("http://localhost:7474/db/data/", 
                   auth_token = "3378f3296094b4e1f7c33dc4287ad757")
           
# Set a timeout of 3 seconds.
graph = startGraph("http://localhost:7474/db/data/", 
                   opts = list(timeout=3))
}

