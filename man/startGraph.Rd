\name{startGraph}
\alias{startGraph}
\title{Connecting to the Database}
\description{
Supply the URL for the location of your Neo4j graph database in order to interact with the graph.
}
\usage{
startGraph(url)
}
\arguments{
  \item{url}{The URL of the graph database. Accepts a string.}
}
\value{
A graph object.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
}

