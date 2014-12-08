\name{ingest}
\alias{ingest}
\title{Add igraph objects to Neo4j}
\description{
Take and igraph object from the igraph package and add it allong with any 
node or edge attributes to the Neo4j.
}
\usage{
ingest(karate, 'knows')
}
\arguments{
  \item{network}{An igraph object.}
  \item{how}{What type of relationship should be created.}
  \item{domain}{A string that either denotes the dataset name or a way to label the subgraph.}
}

\examples{
graph = startGraph("http://localhost:7474/db/data/")

require("igraph")
require("igraphdata")

data(karate)
ingest(karate, 'knows')
}

