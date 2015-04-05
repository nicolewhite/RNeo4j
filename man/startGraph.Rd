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
# A Neo4j <= 2.1 db.
graph = startGraph("http://localhost:7474/db/data/")
                   
# A Neo4j >= 2.2 db.
graph = startGraph("http://localhost:7474/db/data/", 
                   username = "neo4j",
                   password = "password")
           
# Set a timeout of 3 seconds.
graph = startGraph("http://localhost:7474/db/data/", 
                   opts = list(timeout=3))
}

