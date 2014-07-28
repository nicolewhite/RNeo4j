\name{importSample}
\alias{importSample}
\title{Import Sample Datasets}
\description{
Populate the graph database with sample datasets supplied with this package.
}
\usage{
importSample(graph, data)
}
\arguments{
  \item{graph}{A graph object.}
  \item{data}{The dataset to be imported. Accepts a string.}
}
\details{
As of now, the only example dataset available is the movie dataset. This can be accessed by setting data = "movies".
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

importSample(graph, "movies")
}