\name{clear}
\alias{clear}
\title{Clear the Database}
\description{
Delete all nodes, relationships, constraints, and indexes from the graph database.
}
\usage{
clear(graph, input = TRUE)
}
\arguments{
  \item{graph}{The graph object to be cleared.}
  \item{input}{Whether or not confirmation (in the form of external input) from the user should be required.}
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)
}