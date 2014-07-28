\name{clear}
\alias{clear}
\title{Delete Nodes and Relationships}
\description{
Delete all nodes, relationships, constraints, and indexes from the graph database. Requires answering a prompt.
}
\usage{
clear(graph)
}
\arguments{
  \item{graph}{The graph object to be cleared.}
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)
}