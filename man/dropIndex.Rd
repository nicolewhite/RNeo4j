\name{dropIndex}
\alias{dropIndex}
\title{Indexing.}
\description{
Drop an index from the graph by label and property key.
}
\usage{
dropIndex(graph, label = character(), key = character(), all = FALSE)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label on which you want to drop an index.}
  \item{key}{The property key by which the label is indexed.}
  \item{all}{Set to TRUE if you want to drop all indices from the graph.}
}
\examples{
# Drop the index on Person nodes by the name property.
dropIndex(graph, "Person", "name")

# Drop all indices in the graph.
dropIndex(graph, all = TRUE)
}