\name{dropIndex}
\alias{dropIndex}
\title{Indexing.}
\description{
Drop all indices for the entire graph or drop an index for a given label and property key.
}
\usage{
dropIndex(graph, label = character(), key = character())
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label for which you want to drop the index.}
  \item{key}{The key for which you want to drop the index.}
}
\details{
If supplying only a graph object, all uniqueness constraints will be deleted from the graph.
}
\examples{
# Drop the index on Person nodes by the name property.
dropIndex(graph, "Person", "name")

# Drop all indices in the graph database.
dropIndex(graph)
}