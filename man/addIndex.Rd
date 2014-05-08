\name{addIndex}
\alias{addIndex}
\title{Indexing.}
\description{
Add an index by label and property key.
}
\usage{
addIndex(graph, label, key)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label on which to add the index.}
  \item{key}{The property key to index on.}
}
\examples{
addIndex(graph, "Person", "name")
}

