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
           opts = list())
}
\arguments{
  \item{url}{The URL of the graph database. Accepts a string.}
  \item{username}{If the database is remote, your username. Accepts a string.}
  \item{password}{If the database is remote, your password. Accepts a string.}
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
           
# Set a timeout of 3 seconds.
graph = startGraph("http://localhost:7474/db/data/", 
                   opts = list(timeout=3))
}

