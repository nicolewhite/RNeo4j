\name{populate}
\alias{populate}
\title{Populate the graph database.}
\description{
Populate the graph database with example data supplied with this package.
}
\usage{
populate(graph, data)
}
\arguments{
  \item{graph}{The graph object to be populated.}
  \item{data}{The dataset to be loaded. Accepts a string.}
}
\details{
As of now, the only example dataset available is the movie dataset. This can be accessed by setting data = "movies".
}
\examples{
populate(graph, "movies")
}