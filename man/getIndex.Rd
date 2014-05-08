\name{getIndex}
\alias{getIndex}
\title{Indexing.}
\description{
Get all indices for a given label or for the entire graph database.
}
\usage{
getIndex(graph, label = character())
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label for which you want to see all indices.}
}
\value{
A data frame.
}
\details{
To view all indices, only supply a graph object.
}
\examples{
# Get all uniqueness constraints on Person nodes.
getIndex(graph, "Person")

# Get all uniqueness constraints in the graph.
getIndex(graph)
}