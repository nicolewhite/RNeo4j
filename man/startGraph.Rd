\name{startGraph}
\alias{startGraph}
\title{Connect to the graph database.}
\description{
Supply the URL for the location of your Neo4j graph database in order to interact with the graph.
}
\usage{
startGraph(url)
}
\arguments{
  \item{url}{The URL for the location of your graph database.}
}
\value{
A graph object.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
}

