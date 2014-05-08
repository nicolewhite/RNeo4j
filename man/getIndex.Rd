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
A data frame. Returns NULL if no indices are found.
}
\details{
Supplying only a graph object as an argument returns all indices in the graph database.
}
\examples{
# Get all indices for the Person label.
getIndex(graph, "Person")

# Get all indices in the graph.
getIndex(graph)
}